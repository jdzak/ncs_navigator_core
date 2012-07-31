# -*- coding: utf-8 -*-

require 'ncs_navigator/core'

require 'case'
require 'forwardable'
require 'set'

module Field
  ##
  # Performs a 3-way merge across the current state of Core's datastore, a
  # fieldwork set sent to a field client, and a corresponding fieldwork set
  # received from a field client.
  #
  # Currently, four entities are merged: {Contact}, {Event}, {Instrument}, and
  # {Response} via {QuestionResponseSet}.
  #
  #
  # Overview
  # ========
  #
  # There are three states for each entity:
  #
  # Original: the state of the entity at fieldwork set checkout
  # Current: the state of the entity at merge start
  # Proposed: the state of the entity from Field
  #
  # Any of the three states may also be blank; to the merge algorithm, this
  # means "the entity does not exist in the given state".
  #
  # Merge, then, is a process of determining a new current state.
  #
  #
  # Atomic vs. non-atomic merge
  # ===========================
  #
  # Contacts, Events, and Instruments can all be merged non-atomically, which
  # means that we can commit changes even in the presence of conflicts.  (Also,
  # we can retry the merge on those entities and progress towards a fully
  # merged state.)
  #
  # QuestionResponseSets, on the other hand, must be merged atomically: if
  # there exist conflicts on any attribute on any Response, none of the
  # Responses in the group can be merged.
  #
  # The difference, then, is one of merge granularity.  It makes sense to merge
  # individual attributes on operational data; however, because responses in
  # surveys can be related to each other in ways that are difficult to merge,
  # we take a conservative all-or-nothing approach.
  #
  # (Just to be clear, this has nothing to do with database transactions; all
  # merge commits occur in the scope of a single transaction.)
  #
  #
  # Resolution algorithm
  # ====================
  #
  # First, we check only whether entities are blank.  If original and current
  # are blank, we can just accept proposed as-is.
  #
  # original#blank?   current#blank?    proposed#blank?   Result
  # --------------------------------------------------------------
  # true              true              true              blank
  # true              true              false             proposed
  # true              false             true              conflict
  # true              false             false             resolve
  # false             true              true              blank
  # false             true              false             conflict
  # false             false             true              current
  # false             false             false             resolve
  #
  # Where the action is "resolve", we look at the entity or attributes
  # (depending on atomicity) and apply the following decision table, where X,
  # Y, and Z represent non-blank values:
  #
  # original    current   proposed    result
  # ------------------------------------------
  # blank       blank     X           X
  # blank       X         blank       X
  # blank       X         X           X
  # blank       X         Y           conflict
  # X           X         X           X
  # X           X         Y           Y
  # X           Y         X           Y
  # X           Y         Y           Y
  # X           Y         Z           conflict
  #
  #
  # Concurrency considerations
  # ==========================
  #
  # While it is possible to concurrently run multiple merges on the same subset
  # of entities, only one merge can win an update race.
  #
  # All entities involved in the merge use ActiveRecord's optimistic locking
  # mechanism, and Merge#save will re-raise ActiveRecord::StaleObjectError.
  module Merge
    attr_accessor :logger
    attr_accessor :conflicts
    attr_accessor :question_response_sets

    def merge
      self.conflicts = ConflictReport.new
      self.question_response_sets ||= {}

      contacts.each { |id, state| merge_entity(state, 'Contact', id) }
      events.each { |id, state| merge_entity(state, 'Event', id) }
      instruments.each { |id, state| merge_entity(state, 'Instrument', id) }
      question_response_sets.each { |id, state| merge_entity(state, 'QuestionResponseSet', id) }
    end

    def build_question_response_sets
      res = {}

      responses.each do |_, state|
        state.each do |name, response|
          res[response.question_id] ||= {}
          res[response.question_id][name] ||= QuestionResponseSet.new
          res[response.question_id][name] << response
        end
      end

      self.question_response_sets = res
    end

    ##
    # Saves the current state of all merged entities.
    #
    # For more complete error reporting, this method attempts to save all
    # entities regardless of whether or not a previous entity or set of
    # entities failed to save.  However, it will return true if and only if all
    # entities were saved.
    #
    # When data dependencies exist, this can lead to spurious errors; however,
    # that can be dealt with by just looking further up in the log.  There's no
    # similar way to discover errors that aren't reported due to an early
    # abort.
    def save
      ActiveRecord::Base.transaction do
        [contacts, events, instruments, question_response_sets].map { |c| save_collection(c) }.all?.tap do |res|
          unless res
            logger.fatal { 'Errors raised during save; rolling back' }
            raise ActiveRecord::Rollback
          end
        end
      end
    end

    def conflicted?
      !conflicts.blank?
    end

    module_function

    N = Case::Not
    S = Case::Struct.new(:o, :c, :p)

    def merge_entity(state, entity, id)
      o = state[:original]
      c = state[:current]
      p = state[:proposed]

      case [o.blank?, c.blank?, p.blank?]
      when [true,     true,     false]; state[:current] = p.to_model
      when [true,     false,    false]; resolve(o, c, p, entity, id)
      when [false,    true,     false]; conflicts.add(entity, id, :self, o, c, p)
      when [false,    false,    false]; resolve(o, c, p, entity, id)
      end
    end

    def resolve(o, c, p, entity, id)
      if c.merge_atomically?
        resolve_atomic(o, c, p, entity, id)
      else
        resolve_nonatomic(o, c, p, entity, id)
      end
    end

    ##
    # @private
    def resolve_atomic(o, c, p, entity, id)
      collapse_with_conflict_tracking(o, c, p, entity, id, :self) do |state|
        c.patch(state)
      end
    end

    ##
    # @private
    def resolve_nonatomic(o, c, p, entity, id)
      patch = {}

      attrs_to_merge = c.class.accessible_attributes

      attrs_to_merge.each do |attr|
        vo = o[attr] if o
        vc = c[attr]
        vp = p[attr]

        logger.debug { "Resolving #{attr}: [o, c, p] = #{[vo, vc, vp].inspect}" }

        collapse_with_conflict_tracking(vo, vc, vp, entity, id, attr) do |state|
          patch[attr] = state
        end
      end

      c.patch(patch)
    end

    ##
    # @private
    def collapse_with_conflict_tracking(o, c, p, entity, id, attr)
      result = collapse(o, c, p)

      if result == :conflict
        logger.debug { "Detected conflict: [o, c, p] = #{[o, c, p].inspect}" }
        conflicts.add(entity, id, attr, o, c, p)
      else
        logger.debug { "Collapsed [o, c, p] = #{[o, c, p].inspect} to #{result.inspect}" }
        yield result
      end
    end

    ##
    # @private
    def collapse(o, c, p)
      case S[o, c, p]
      when S[nil, nil, p]; p
      when S[nil, c, nil]; c
      when S[nil, c, c];   c
      when S[nil, c, p];   :conflict
      when S[o, o, o];     o
      when S[o, o, p];     p
      when S[o, c, o];     c
      when S[o, c, c];     c
      when S[o, c, p];     :conflict
      end
    end

    ##
    # @private
    # @return Boolean
    def save_collection(c)
      c.map do |public_id, state|
        current = state[:current]

        next true unless current

        current.save.tap { |ok| log_errors_for(public_id, current, ok) }
      end.all?
    end

    def log_errors_for(public_id, entity, ok)
      return if ok

      logger.fatal { "[#{entity.class} #{public_id}] #{entity.class} could not be saved" }

      entity.errors.to_a.each do |error|
        logger.fatal { "[#{entity.class} #{public_id}] Validation error: #{error.inspect}" }
      end
    end
  end
end