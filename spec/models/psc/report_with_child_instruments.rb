require 'spec_helper'

require File.expand_path('../activity_label_helpers', __FILE__)

shared_context 'report with child instruments' do
  include ActivityLabelHelpers

  let(:data) do
    JSON.parse(%Q{
      {
          "filters": {
              "end_date": "2012-07-16",
              "responsible_user": "user",
              "start_date": "2012-07-09",
              "states": [
                  "Scheduled"
              ]
          },
          "rows": [
              {
                  "activity_name": "Birth Interview",
                  "activity_status": "Scheduled",
                  "activity_type": "Instrument",
                  "grid_id": "ccb30379-b036-45a2-881b-454e9b42389d",
                  "ideal_date": "2012-07-06",
                  "labels": [
                      "event:birth",
                      "instrument:#{mdes_version}:ins_que_birth_int_ehpbhi_p2_v2.0_baby_name",
                      "order:01_01",
                      "participant_type:child",
                      "references:#{mdes_version}:ins_que_birth_int_ehpbhi_p2_v2.0"
                  ],
                  "responsible_user": "user",
                  "scheduled_date": "2012-07-10",
                  "scheduled_study_segment": {
                      "grid_id": "7b3f6868-13cf-4c7b-9f16-d2b2eee08fbc",
                      "start_date": "2012-07-06",
                      "start_day": 1
                  },
                  "site": "GCSC",
                  "study": "NCS Hi-Lo",
                  "subject": {
                      "grid_id": "7eaf6393-b7a9-4888-b32f-d6bde6436b3e",
                      "name": "Liz",
                      "person_id": "2f85c94e-edbb-4cbe-b9ab-5f12c033323f"
                  }
              },
              {
                  "activity_name": "Birth Interview",
                  "activity_status": "Scheduled",
                  "activity_type": "Instrument",
                  "grid_id": "ccb30379-b036-45a2-881b-454e9b42389d",
                  "ideal_date": "2012-07-06",
                  "labels": [
                      "event:birth",
                      "instrument:#{mdes_version}:ins_que_birth_int_ehpbhi_p2_v2.0",
                      "participant_type:mother"
                  ],
                  "responsible_user": "user",
                  "scheduled_date": "2012-07-10",
                  "scheduled_study_segment": {
                      "grid_id": "7b3f6868-13cf-4c7b-9f16-d2b2eee08fbc",
                      "start_date": "2012-07-06",
                      "start_day": 1
                  },
                  "site": "GCSC",
                  "study": "NCS Hi-Lo",
                  "subject": {
                      "grid_id": "7eaf6393-b7a9-4888-b32f-d6bde6436b3e",
                      "name": "Liz",
                      "person_id": "2f85c94e-edbb-4cbe-b9ab-5f12c033323f"
                  }
              }
          ]
      }
    })
  end

  let(:activity_name) { 'Birth Interview' }
  let(:event_birth) { al('event:birth') }
  let(:event_labels) { [event_birth] }
  let(:ideal_date) { '2012-07-06' }
  let(:instrument_baby_name) { al("instrument:#{mdes_version}:ins_que_birth_int_ehpbhi_p2_v2.0_baby_name") }
  let(:instrument_birth) { al("instrument:#{mdes_version}:ins_que_birth_int_ehpbhi_p2_v2.0") }
  let(:mdes_version) { NcsNavigatorCore.mdes_version.number }
  let(:person_id) { '2f85c94e-edbb-4cbe-b9ab-5f12c033323f' }
  let(:scheduled_date) { '2012-07-10' }
  let(:survey_labels) { [instrument_birth, instrument_baby_name] }
end
