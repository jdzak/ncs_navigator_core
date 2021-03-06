# -*- coding: utf-8 -*-

namespace :import do
  task :warehouse_setup do |t|
    class << t; attr_accessor :config; end

    source_warehouse_config_file = ENV['IMPORT_CONFIG'] || '/etc/nubic/ncs/warehouse/import.rb'

    require 'ncs_navigator/warehouse'

    t.config = NcsNavigator::Warehouse::Configuration.
      from_file(source_warehouse_config_file)
    t.config.set_up_logs

    NcsNavigator::Warehouse::DatabaseInitializer.new(t.config).set_up_repository
  end

  task :psc_setup => :environment do |t|
    require 'highline'
    require 'aker/cas_cli'
    class << t; attr_accessor :user; end

    aker_cas_cli_options = {}
    if ENV['DEV_ENV']
      aker_cas_cli_options = { :verify_mode => OpenSSL::SSL::VERIFY_NONE }
    end

    cas_cli = Aker::CasCli.new(Aker.configuration, aker_cas_cli_options)

    hl = HighLine.new
    username = hl.ask("Username for PSC: ")
    password = hl.ask("Password for PSC: ") { |q| q.echo = '*' }

    t.user = cas_cli.authenticate(username, password)
    @import_user = 'operational_importer_psc_sync'
  end

  def non_children_participants
    Participant.includes([{:participant_person_links => [:person]}, :events]).
      where('p_type_code != ?', 6)
  end

  task :find_followed_participants_for_psc => :environment do |t|
    class << t; attr_accessor :participants; end

    # Expected participants for PSC are those 1) not children and 2) actively followed.
    t.participants = non_children_participants.where('being_followed = ?', true)
  end

  task :set_whodunnit do
    PaperTrail.whodunnit = ['rake', ARGV].flatten.join(' ')
  end

  def import_wh_config
    task('import:warehouse_setup').config
  end

  def user_for_psc
    task('import:psc_setup').user
  end

  def psc
    PatientStudyCalendar.new(user_for_psc, NcsNavigatorCore.psc_logger)
  end

  def expected_followed_participants_for_psc
    task('import:find_followed_participants_for_psc').participants
  end

  desc 'Import all data'
  task :all => [
    :psc_setup,
    :operational, :operational_psc, :unused_operational,
    :instruments
  ]

  desc 'Import operational data'
  task :operational => [:warehouse_setup, :environment] do
    require 'ncs_navigator/core'

    importer_options = {}

    if ENV['FOLLOWED_CSV']
      followed = NcsNavigator::Core::FollowedParticipantChecker.new(ENV['FOLLOWED_CSV'])
      importer_options[:followed_p_ids] = followed.expected_p_ids
    end

    importer = NcsNavigator::Core::Warehouse::OperationalImporter.new(
      import_wh_config, importer_options)

    tables = case
             when ENV['TABLES']
               ENV['TABLES'].split(',').collect(&:to_sym)
             when ENV['START_WITH']
               start = ENV['START_WITH'].to_sym
               all_tables = importer.automatic_producers.collect(&:name)
               start_i = all_tables.index(start)
               unless start_i
                 fail "Can't start from Unknown table #{start}"
               end
               all_tables[start_i .. all_tables.size] + [:events, :link_contacts, :instruments]
             else
               []
             end

    puts "Importing only #{tables.join(', ')}." unless tables.empty?

    importer.import(*tables)
  end

  desc 'Synchronize PSC to the data imported by import:operational'
  task :operational_psc => [:psc_setup, :warehouse_setup, :environment] do
    require 'ncs_navigator/core'

    importer = NcsNavigator::Core::Warehouse::OperationalImporterPscSync.new(psc, import_wh_config)
    importer.import(@import_user)
  end

  desc 'Reset the PSC sync caches so that the PSC sync can be retried. (You should wipe the subject info in PSC also.)'
  task 'operational_psc:reset' => [:psc_setup, :warehouse_setup, :environment] do
    require 'ncs_navigator/core'

    importer = NcsNavigator::Core::Warehouse::OperationalImporterPscSync.new(psc, import_wh_config)
    importer.reset(@import_user)
  end

  desc 'Check for imported participants which are not in PSC'
  task 'operational_psc:check' => [:psc_setup, :warehouse_setup, :environment, :find_followed_participants_for_psc] do
    require 'ncs_navigator/core'

    missing_ps = expected_followed_participants_for_psc.reject { |p|
      psc.is_registered?(p).tap do |result|
        $stderr.write(result ? '.' : '!')
        $stderr.flush
      end
    }
    $stderr.puts

    if missing_ps.empty?
      $stderr.puts "All #{expected_followed_participants_for_psc.size} expected participant#{'s' unless expected_followed_participants_for_psc.size == 1} present."
    else
      $stderr.puts "The following participant#{'s' unless missing_ps.size == 1} expected but not present:"
      missing_ps.each do |p|
        $stderr.puts "* #{p.public_id} (cases: #{p.id})"
      end
    end
  end

  desc 'Import instrument data'
  task :instruments => [:warehouse_setup, :environment] do
    require 'ncs_navigator/core'

    importer = NcsNavigator::Core::Warehouse::LegacyInstrumentImporter.new(import_wh_config)
    importer.import
  end

  desc 'Pass unused operational data through to an XML file'
  task :unused_operational => [:warehouse_setup, :environment] do
    require 'ncs_navigator/core'

    pass = NcsNavigator::Core::Warehouse::UnusedOperationalPassthrough.new(import_wh_config)
    pass.import
  end

  desc 'Pass staff and outreach data through to an XML file'
  task :archive_staff => [:warehouse_setup, :environment] do
    require 'ncs_navigator/core'

    pass = NcsNavigator::Core::Warehouse::ArchivalStaffAndOutreachPassthrough.new(import_wh_config)
    pass.import
  end

  desc 'Schedule upcoming events for followed participants if needed'
  task :schedule_participant_events => [:psc_setup, :environment, :set_whodunnit, :find_followed_participants_for_psc]  do
    ps_to_advance = expected_followed_participants_for_psc.select { |p| p.pending_events.empty? }

    $stderr.puts "#{ps_to_advance.size} of #{expected_followed_participants_for_psc.size} followed participants need pending events."

    ps_to_advance.each_with_index do |p, i|
      $stderr.print("\rAdvancing #{i + 1}/#{ps_to_advance.size} to next state...")
      Rails.logger.info("Advancing imported case #{p.p_id} to next state")

      last_event = p.events.chronological.last

      Rails.logger.info("- Currently #{p.state.inspect}")
      Rails.logger.info("- Updating based on #{last_event.event_type} on #{last_event.event_start_date}")
      p.update_state_to_next_event(last_event)
      Rails.logger.info("- Updated to #{p.state.inspect}")

      Rails.logger.info("- Scheduling in PSC...")
      Event.schedule_and_create_placeholder(psc, p)
      p.events.reload # for next log statement
      Rails.logger.info("- PSC scheduling completed. Pending events are now #{p.pending_events.collect { |e| e.event_type.to_s }.inspect}")
      if p.pending_events.empty?
        $stderr.puts("\n#{p.p_id} still has no pending events! Its last event was #{last_event.event_type} (#{last_event.event_type.local_code}) on #{last_event.event_start_date} (#{last_event.event_id}). Its current state is #{p.state.inspect}.")
      end
    end
    $stderr.puts("\rAdvanced #{ps_to_advance.size} case(s) to next state.")
  end

  desc 'Re-schedule events that are pending (i.e. w/out an event_end_date)'
  task :reschedule_pending_events => [:psc_setup, :environment] do
    date = 4.days.from_now.to_date

    events = Event.where("participant_id is not null and event_end_date is null and event_type_code <> 29").all

    events.each do |event|
      reason = "Import task: Rescheduling pending event [#{event.event_id}] #{event.event_type} to #{date}."
      psc.reschedule_pending_event(event, date, reason)
    end
  end

  eroc_deps = [:environment, :set_whodunnit]
  unless ENV['NO_PSC']
    eroc_deps = [:psc_setup, :warehouse_setup] + eroc_deps
  end

  desc 'Import an EROC'
  task :eroc, [:eroc_csv] => eroc_deps do |t, args|
    fail 'Please specify the path to the EROC csv' unless args[:eroc_csv]

    require 'ncs_navigator/core'

    options = {}
    unless ENV['NO_PSC']
      options[:psc] = psc
      options[:wh_config] = import_wh_config
    end

    importer = NcsNavigator::Core::RecordOfContactImporter.new(
      File.open(args[:eroc_csv]),
      options
    )

    unless importer.import_data
      fail importer.errors.join("\n")
    end
  end

  desc 'Register Participants to the PSC'
  task :register_to_psc, [:participant_csv] => [:psc_setup, :warehouse_setup, :environment, :set_whodunnit] do |t, args|
    fail 'Please specify the path to the participant csv' unless args[:participant_csv]

    require 'ncs_navigator/core'
    processor = NcsNavigator::Core::PscRegistrationProcessor.new(
      File.open(args[:participant_csv]),
      psc,
      import_wh_config
    )
    processor.register_to_psc
  end

  desc 'Looks for participants with "extra" events'
  task :find_extra_events => :environment do
    Participant.includes(:events).each do |p|
      problematic_event_sets = p.events.
        select { |e| Event.participant_one_time_only_event_type_codes.include?(e.event_type_code) }.
        each_with_object({}) { |event, idx| (idx[event.event_type_code] ||= []) << event }.
        select { |type, events| events.size > 1 }.
        collect { |type, events| events }

      unless problematic_event_sets.empty?
        puts "Participant #{p.public_id} has extra events for one-time-only type#{'s' if problematic_event_sets.size != 1}:"
        problematic_event_sets.each do |events|
          puts "* #{events.first.event_type.display_text}: #{events.collect(&:event_start_date).join(' | ')}"
        end
      end
    end
  end

  namespace :followed do
    desc "Report any mismatches between followedness in the CSV and in Cases"
    task :check, [:followed_csv] => :environment do |t, args|
      fail 'Please specify the path to the expected-followed csv' unless args[:followed_csv]
      require 'ncs_navigator/core'

      NcsNavigator::Core::FollowedParticipantChecker.new(args[:followed_csv]).report
    end

    desc "Force Cases to match the followedness data in the CSV"
    task :update, [:followed_csv] => :environment do |t, args|
      fail 'Please specify the path to the expected-followed csv' unless args[:followed_csv]
      require 'ncs_navigator/core'

      $stderr.puts "Before:"
      NcsNavigator::Core::FollowedParticipantChecker.new(args[:followed_csv]).tap do |checker|
        checker.report
        checker.update!
      end

      $stderr.puts "After:"
      NcsNavigator::Core::FollowedParticipantChecker.new(args[:followed_csv]).report
    end
  end

  desc 'Schedule Re-consent Event for a particular date for all followed Participants'
  task :schedule_reconsent => [:psc_setup, :environment, :set_whodunnit, :find_followed_participants_for_psc] do
    require 'highline'

    hl = HighLine.new
    date_str = hl.ask("Date to schedule reconsent ['YYYY-MM-DD']: ")

    begin
      date = Date.parse(date_str)

      participants_unable_to_be_scheduled = NcsNavigator::Core::ReconsentScheduler.new(
        expected_followed_participants_for_psc, date).schedule(psc)

      result = "All #{expected_followed_participants_for_psc.size} participants scheduled for reconsent."
      unless participants_unable_to_be_scheduled.empty?
        result = "#{participants_unable_to_be_scheduled.size} participants need to be rescheduled.\n"
        result << "#{participants_unable_to_be_scheduled.map(&:p_id).join(',')}"
      end
      $stderr.puts(result)
      Rails.logger.info(result)

    rescue ArgumentError
      $stderr.puts("Was unable to parse given date [#{date_str}].")
    end
  end

  desc 'Cancel scheduled events that have no matching mdes versioned instrument in PSC for followed participants'
  task :cancel_activities_with_non_matching_mdes_instruments => [:psc_setup, :environment, :set_whodunnit]  do
    non_children_participants.each do |part|
      msg = "Looking for activities to cancel for participant #{part.p_id}..."
      $stderr.puts(msg)
      Rails.logger.info(msg)

      if part.person.nil?
        per_nil_msg = "No person exists for #{part.p_id}"
        $stderr.puts(per_nil_msg)
        Rails.logger.info(per_nil_msg)
        next
      else
        psc.scheduled_activities(part).each do |a|
          if a.has_non_matching_mdes_version_instrument?
            msg = "Activity #{a.activity_name} has non matching mdes versioned instrument. Canceling activity for participant #{part.p_id}."
            $stderr.puts("#{msg}")
            Rails.logger.info(msg)
            reason = "Does not include an instrument for MDES version #{NcsNavigatorCore.mdes.version}."
            psc.update_activity_state(a.activity_id, part, Psc::ScheduledActivity::CANCELED, Date.parse(a.ideal_date), reason)
          end
        end
      end
    end
  end

  desc 'Cancel collection activities if not expanded phase two'
  task :cancel_collection_activities => [:psc_setup, :environment, :set_whodunnit]  do
    if NcsNavigatorCore.expanded_phase_two?
      msg = "No need to cancel activities. Cases is configured for expanded phase two."
      $stderr.puts("#{msg}")
      Rails.logger.info(msg)
    else
      non_children_participants.each do |part|
        if part.person.nil?
          per_nil_msg = "No person exists for #{part.p_id}"
          $stderr.puts(per_nil_msg)
          Rails.logger.info(per_nil_msg)
          next
        else
          msg = "Looking for activities to cancel for participant #{part.p_id}..."
          $stderr.puts(msg)
          Rails.logger.info(msg)
          psc.scheduled_activities(part).each do |a|
            if Instrument.collection?(a.labels)
              msg = "Activity #{a.activity_name} is a collection activity. Canceling activity for participant #{part.p_id}."
              $stderr.puts("#{msg}")
              Rails.logger.info(msg)
              reason ="Study Center is not configured to collection samples or specimens."
              psc.update_activity_state(a.activity_id, part, Psc::ScheduledActivity::CANCELED, Date.parse(a.ideal_date), reason)
            end
          end
        end
      end
    end
  end

  desc 'Cancel consent activities for participants who have already consented'
  task :cancel_consent_activities => [:psc_setup, :environment, :set_whodunnit]  do
    non_children_participants.each do |part|
      msg = "Looking for activities to cancel for participant #{part.p_id}..."
      $stderr.puts(msg)
      Rails.logger.info(msg)

      if part.person.nil?
        per_nil_msg = "No person exists for #{part.p_id}"
        $stderr.puts(per_nil_msg)
        Rails.logger.info(per_nil_msg)
        next
      elsif part.consented?
        psc.scheduled_activities(part).each do |a|
          if a.cancelable_consent_activity?
            msg = "Activity #{a.activity_name} is a consent activity. Canceling activity for participant #{part.p_id}."
            $stderr.puts("#{msg}")
            Rails.logger.info(msg)
            reason = msg
            psc.update_activity_state(a.activity_id, part, Psc::ScheduledActivity::CANCELED, Date.parse(a.ideal_date), reason)
          end
        end
      else
        msg = "No need to cancel activities for participant. #{participant} has not yet consented."
        $stderr.puts("#{msg}")
        Rails.logger.info(msg)
      end
    end
  end

end
