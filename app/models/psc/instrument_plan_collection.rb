require 'forwardable'

module Psc
  ##
  # Given a collection of {ScheduledActivity} objects, groups them by event
  # label and activity ID, and generates a corresponding set of
  # {Psc::InstrumentPlan} objects.
  #
  # Plans are grouped by [person, event, instrument].
  class InstrumentPlanCollection
    extend Forwardable
    include Enumerable

    def_delegators :@plans, :each

    attr_reader :activities
    attr_reader :groups

    def self.for(activities)
      new(activities).tap(&:calculate)
    end

    def initialize(activities = nil)
      @activities = activities || []
      @plans = []
    end

    def add_activity(a)
      activities << a
    end

    def group
      @groups = {}

      activities.each do |a|
        group = [a.contact, a.event]
        @groups[group] ||= []
        @groups[group] << a
      end
    end

    def calculate
      @plans = []

      group

      groups.values.each do |activities|
        @plans += plans_for_group(activities)
      end

      @plans.each(&:order)
    end

    ##
    # @private
    def plans_for_group(activities)
      plans = {}

      roots, children = activities.partition(&:instrument)

      roots.each do |activity|
        root = activity.instrument

        plans[activity.survey.access_code] = InstrumentPlan.new(root, [activity.survey])
      end

      children.select(&:referenced_survey).each do |activity|
        referenced_code = activity.referenced_survey.access_code

        unless plans.has_key?(referenced_code)
          raise "Activity #{activity.activity_id} references unknown survey #{referenced_code}"
        end

        plans[referenced_code].surveys << activity.survey
      end

      plans.values
    end
  end
end