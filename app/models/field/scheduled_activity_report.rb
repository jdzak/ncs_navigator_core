require 'ncs_navigator/core'

module Field
  class ScheduledActivityReport < ::Psc::ScheduledActivityReport
    include ::Psc::ScheduledActivityReport::EntityResolution
    include NcsNavigator::Core::Fieldwork::Adapters

    def as_json(options = nil)
      {
        'contacts' => contacts_as_json(options),
        'instrument_plans' => instrument_plans_as_json(options),
        'participants' => participants_as_json(options)
      }
    end

    ##
    # @private
    def contacts_as_json(options)
      contacts.map do |c|
        mc = m c
        mp = m c.person

        if mc && mp
          adapt_model(mc).as_json(options).merge({
            'events' => events_as_json(c, c.person, options),
            'person_id' => mp.person_id,
            'version' => mc.updated_at.utc
          })
        end
      end.compact
    end

    ##
    # @private
    def events_as_json(contact, person, options)
      events.select { |e| e.contact == contact && e.person == person }.map do |e|
        me = m e

        if me
          adapt_model(me).as_json(options).merge({
            'name' => me.event_type.to_s,
            'instruments' => instruments_as_json(e, person, options),
            'version' => me.updated_at.utc
          })
        end
      end.compact
    end

    ##
    # @private
    def instruments_as_json(event, person, options)
      map_instruments_to_plans

      instruments.select { |i| i.event == event && i.person == person }.map do |i|
        mi = m i
        plan = plan_for(i)

        if mi && plan
          adapt_model(mi).as_json(options).merge({
            'instrument_plan_id' => plan.id,
            'name' => i.name,
            'response_sets' => mi.response_sets
          })
        end
      end.compact
    end

    ##
    # @private
    def instrument_plans_as_json(options)
      instrument_plans.map do |p|
        { 'instrument_plan_id' => p.id,
          'instrument_templates' => instrument_templates_as_json(p, options)
        }
      end
    end

    ##
    # @private
    def instrument_templates_as_json(plan, options)
      plan.surveys.map do |s|
        ms = m s

        if ms
          {
            'instrument_template_id' => ms.api_id,
            'participant_type' => s.participant_type,
            'survey' => ms,
            'version' => ms.updated_at.utc
          }
        end
      end.compact
    end

    ##
    # @private
    def map_instruments_to_plans
      @plan_map = {}.tap do |h|
        instrument_plans.each { |p| h[p.root] = p }
      end
    end

    ##
    # @private
    def plan_for(instrument)
      @plan_map[instrument]
    end

    ##
    # @private
    def participants_as_json(options)
      participants = {}

      people.each do |p|
        pm = m p
        participant = pm.try(:participant)

        next unless participant && pm

        if participants.has_key?(participant)
          participants[participant] << pm
        else
          participants[participant] = [pm]
        end
      end

      participants.map do |pa, ps|
        { 'p_id' => pa.p_id,
          'version' => pa.updated_at.utc,
          'persons' => ps.map { |p| person_as_json(p, pa, options) }
        }
      end
    end

    ##
    # @private
    def person_as_json(person, participant, options)
      link = participant.participant_person_links.detect { |p| p.person_id == person.id }
      addr = person.primary_address

      { 'name' => person.name,
        'person_id' => person.person_id,
        'relationship_code' => link.relationship_code.to_i,
        'cell_phone' => person.primary_cell_phone.try(:phone_nbr),
        'email' => person.primary_email.try(:email),
        'home_phone' => person.primary_home_phone.try(:phone_nbr),
        'version' => person.updated_at.utc
      }.merge(address_as_json(addr, options))
    end

    ##
    # @private
    def address_as_json(address, options)
      return {} unless address

      { 'city' => address.city,
        'state' => address.state.try(:display_text),
        'street' => [address.address_one, address.address_two].join("\n"),
        'zip_code' => [address.zip, address.zip4].join('-')
      }
    end
  end
end
