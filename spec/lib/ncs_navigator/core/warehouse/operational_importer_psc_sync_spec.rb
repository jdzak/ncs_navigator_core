require 'spec_helper'
require Rails.root + 'spec/warehouse_setup'

require 'ncs_navigator/core/warehouse'

module NcsNavigator::Core::Warehouse
  describe OperationalImporterPscSync do
    include NcsNavigator::Core::Spec::WarehouseSetup

    SEGMENT_IDS = {
      :pv1 => 'ca65bbbb-7e47-4f71-a4f0-071e7f73f380',
      :pv2 => 'cef89a1e-5a08-4d94-811d-1aea62700d61',
      :hi_child => '072db970-d32a-4006-83b0-3f0240833894',
      :lo_birth => '53318f20-d21f-452e-a8e8-3f2ed6bb6c93'
    }

    let(:redis) { Rails.application.redis }
    let(:ns) { 'NcsNavigator::Core::Warehouse::OperationalImporter' }

    let(:psc) { double(PatientStudyCalendar) }
    let(:psc_participant) { double(PscParticipant) }

    let(:importer) { OperationalImporterPscSync.new(psc, wh_config) }
    let(:template_xml) {
      Nokogiri::XML(File.read(File.expand_path(
            '../../../../../fixtures/psc/current_hilo_template_snapshot.xml', __FILE__)))
    }

    before do
      keys = redis.keys('*')
      redis.del(*keys) unless keys.empty?

      psc.stub!(:psc_participant).and_return(psc_participant)
      psc.stub!(:template_snapshot).and_return(template_xml)
      psc_participant.stub!(:psc).and_return(psc)
    end

    def add_event_hash(event_id, start_date, overrides={})
      key = "#{ns}:psc_sync:event:#{event_id}"
      redis.hmset(key, *{
          :status => 'new',
          :event_id => event_id,
          :start_date => start_date,
          :sort_key => "#{start_date}:030"
        }.merge(overrides).to_a.flatten)
    end

    # mini-integration tests; details are tested below
    describe '#import' do
      it 'schedules segments for events'
      it 'updates activity states from linked contacts'
      it 'updates activity states for closed events'
    end

    describe 'scheduling segments for events' do
      let(:p_id) { 'par-foo' }
      let(:person_id) { 'per-foo' }

      let(:participant) { Factory(:participant, :p_id => p_id) }
      let(:person) { Factory(:person, :person_id => person_id) }

      before do
        participant.person = person
        participant.stub!(:low_intensity?).and_return(false)

        psc_participant.stub!(:participant).and_return(participant)
        psc_participant.stub!(:scheduled_events).and_return([{}])
        psc_participant.stub!(:registered?).and_return(true)
        psc_participant.stub!(:append_study_segment)

        redis.sadd("#{ns}:psc_sync:participants", p_id)
        %w(e10 e4 e1).each do |e|
          redis.sadd("#{ns}:psc_sync:p:#{p_id}:events", e)
        end
        add_event_hash('e4', '2010-04-04',
          :event_type_label => 'pregnancy_visit_2')
        add_event_hash('e1', '2010-01-11',
          :event_type_label => 'pregnancy_visit_1')
        add_event_hash('e10', '2010-10-10',
          :event_type_label => 'birth')
      end

      it 'schedules events in order by start date' do
        psc_participant.should_receive(:append_study_segment).
          with('2010-01-11', SEGMENT_IDS[:pv1]).ordered
        psc_participant.should_receive(:append_study_segment).
          with('2010-04-04', SEGMENT_IDS[:pv2]).ordered
        psc_participant.should_receive(:append_study_segment).
          with('2010-10-10', SEGMENT_IDS[:hi_child]).ordered

        importer.schedule_events(psc_participant)
      end

      describe 'when the participant has no PSC schedule' do
        it 'assigns the participant to the study in PSC using the event to find the first segment' do
          psc_participant.should_receive(:registered?).any_number_of_times.
            # first false, then true subsequent times
            and_return(false, true)

          psc_participant.should_receive(:register!).
            with('2010-01-11', SEGMENT_IDS[:pv1])

          importer.schedule_events(psc_participant)
        end
      end

      describe 'when the event already has scheduled activities' do
        shared_examples_for 'a new event' do
          before do
            psc_participant.stub!(:scheduled_events).and_return([{
                  :event_type_label => 'pregnancy_visit_1',
                  :start_date => start_date,
                  :scheduled_activities => ['dc']
                }])
          end

          it 'schedules a new segment' do
            psc_participant.should_receive(:append_study_segment).
              with('2010-01-11', SEGMENT_IDS[:pv1])

            importer.schedule_events(psc_participant)
          end
        end

        shared_examples_for 'an already scheduled event' do
          before do
            psc_participant.stub!(:scheduled_events).and_return([{
                  :event_type_label => 'pregnancy_visit_1',
                  :start_date => start_date,
                  :scheduled_activities => ['dc']
                }])
          end

          it 'does not schedule a new segment' do
            psc_participant.should_not_receive(:append_study_segment).
              with('2010-01-11', SEGMENT_IDS[:pv1])

            importer.schedule_events(psc_participant)
          end
        end

        describe 'and the activity ideal date is 15 days before the event start date' do
          let(:start_date) { '2009-12-27' }

          it_behaves_like 'a new event'
        end

        describe 'and the activity ideal date is 14 days before the event start date' do
          let(:start_date) { '2009-12-28' }

          it_behaves_like 'an already scheduled event'
        end

        describe 'and the activity ideal date is the same as the event start date' do
          let(:start_date) { '2010-01-11' }

          it_behaves_like 'an already scheduled event'
        end

        describe 'and the activity ideal date is 14 days after the event start date' do
          let(:start_date) { '2010-01-25' }

          it_behaves_like 'an already scheduled event'
        end

        describe 'and the activity ideal date is 15 days after the event start date' do
          let(:start_date) { '2010-01-26' }

          it_behaves_like 'a new event'
        end
      end

      describe 'when there is no existing segment with a matching type and date' do
        describe 'when the event type is birth' do
          before do
            psc_participant.stub!(:append_study_segment)
          end

          it 'schedules the lo birth segment when the participant is lo' do
            participant.should_receive(:low_intensity?).at_least(:once).and_return(true)
            psc_participant.should_receive(:append_study_segment).
              with('2010-10-10', SEGMENT_IDS[:lo_birth]).ordered

            importer.schedule_events(psc_participant)
          end

          it 'schedules the hi birth segment when the participant is hi' do
            participant.should_receive(:low_intensity?).and_return(false)
            psc_participant.should_receive(:append_study_segment).
              with('2010-10-10', SEGMENT_IDS[:hi_child]).ordered

            importer.schedule_events(psc_participant)
          end
        end

        describe 'when there are multiple candidate segments' do
          let(:unschedulable_key) { "#{ns}:psc_sync:p:#{p_id}:events_unschedulable" }

          before do
            add_event_hash('e2', '2010-01-11',
              :sort_key => '2010-01-11:010',
              :event_type_label => 'informed_consent')
            redis.sadd("#{ns}:psc_sync:p:#{p_id}:events", 'e2')
          end

          it 'defers the decision until later then uses an existing segment' do
            psc_participant.should_receive(:scheduled_events).exactly(5).times.and_return(
              [], [], [], [],
              [{ :event_type_label => 'informed_consent', :start_date => '2010-01-01' }]
            )

            importer.schedule_events(psc_participant)

            redis.smembers(unschedulable_key).should == []
          end

          it 'registers events that were never syncable' do
            psc_participant.should_receive(:scheduled_events).exactly(5).times.and_return([])

            importer.schedule_events(psc_participant)

            redis.smembers(unschedulable_key).should == %w(e2)
          end
        end
      end

      it 'queues a closed event for later close processing' do
        redis.hset("#{ns}:psc_sync:event:e4", 'end_date', '2010-04-07')

        importer.schedule_events(psc_participant)

        redis.smembers("#{ns}:psc_sync:p:#{p_id}:events_closed").should == %w(e4)
      end
    end
  end
end
