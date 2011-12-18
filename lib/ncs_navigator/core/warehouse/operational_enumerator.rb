require 'ncs_navigator/core'

require 'ncs_navigator/warehouse/models/two_point_zero'

module NcsNavigator::Core::Warehouse
  ##
  # Converts the contents of a core instance into appropriate MDES
  # model instances for MDES Warehouse.
  class OperationalEnumerator
    include NcsNavigator::Warehouse::Transformers::Database
    include NcsNavigator::Warehouse::Models::TwoPointZero

    extend DatabaseEnumeratorHelpers

    bcdatabase :name => 'ncs_navigator_core'

    on_unused_columns :fail
    ignored_columns :id, :transaction_type, :updated_at, :created_at, :being_processed

    produce_one_for_one(:listing_units, ListingUnit)

    produce_one_for_one(:dwelling_units, DwellingUnit,
      :public_ids => [
        { :table => :listing_units, :public_id => :list_id }
      ]
    )

    produce_one_for_one(:household_units, HouseholdUnit,
      :column_map => {
        :hh_eligibility_code => :hh_elig,
        :number_of_age_eligible_women => :num_age_elig,
        :number_of_pregnant_women => :num_preg,
        :number_of_pregnant_minors => :num_preg_minor,
        :number_of_pregnant_adults => :num_preg_adult,
        :number_of_pregnant_over49 => :num_preg_over49
      }
    )

    produce_one_for_one(:dwelling_household_links, LinkHouseholdDwelling,
      :public_ids => [
        { :table => :dwelling_units, :public_id => :du_id },
        { :table => :household_units, :public_id => :hh_id }
      ]
    )

    produce_one_for_one(:people, Person,
      :column_map => {
        :language_code => :person_lang,
        :language_other => :person_lang_oth,
        :marital_status_code => :maristat,
        :marital_status_other => :maristat_oth,
        :preferred_contact_method_code => :pref_contact,
        :preferred_contact_method_other => :pref_contact_oth,
        :planned_move_code => :plan_move
      },
      :ignored_columns => %w(person_dob_date date_move_date)
    )

    produce_one_for_one(:household_person_links, LinkPersonHousehold,
      :public_ids => [
        { :table => :people, :join_column => :person_id },
        { :table => :household_units, :public_id => :hh_id }
      ]
    )

    # TODO: maybe unnecessary
#    produce_records :link_participant_self_person, :query => %Q(
#      SELECT p.person_id, par.p_id
#      FROM people p INNER JOIN participants par ON p.id=par.person_id
#    ) do |row|
#      LinkPersonParticipant.new(
#        :person_pid_id => [row.p_id, '-self'].join(''),
#        :person_id => row.person_id,
#        :p_id => row.p_id,
#        :relation => '1', # self
#        :is_active => '1' # yes
#      )
#    end

    produce_one_for_one(:person_races, PersonRace,
      :public_ids => [
        { :table => :people, :join_column => :person_id }
      ]
    )

    produce_one_for_one(:participants, Participant,
      :column_map => {
        :pid_age_eligibility_code => :pid_age_elig
      },
      :ignored_columns => %w(person_id high_intensity low_intensity_state high_intensity_state)
    )

    produce_one_for_one(:participant_person_links, LinkPersonParticipant,
      :public_ids => [
        { :table => :people, :join_column => :person_id },
        :participants
      ],
      :column_map => {
        :relationship_code => :relation,
        :relationship_other => :relation_oth,
      }
    )

    produce_one_for_one(:participant_consents, ParticipantConsent,
      :public_ids => [
        :participants,
        :contacts,
        { :table => :people,
          :public_id => :person_id,
          :public_ref => :person_who_consented_id },
        { :table => :people,
          :public_id => :person_id,
          :public_ref => :person_wthdrw_consent_id }
      ]
    )

    produce_one_for_one(:participant_consent_samples, ParticipantConsentSample,
      :public_ids => %w(participants participant_consents)
    )

    produce_one_for_one(:participant_authorization_forms, ParticipantAuth,
      :public_ids => %w(participants contacts)
    )

    produce_one_for_one(:participant_visit_consents, ParticipantVisConsent,
      :public_ids => [
        :participants,
        :contacts,
        { :table => :people,
          :public_id => :person_id,
          :public_ref => :vis_person_who_consented_id }
      ]
    )

    produce_one_for_one(:participant_visit_records, ParticipantRvis,
      :public_ids => [
        :participants,
        :contacts,
        { :table => :people,
          :public_id => :person_id,
          :join_column => :rvis_person_id,
          :public_ref => :rvis_person }
      ]
    )

    produce_one_for_one(:ppg_details, PpgDetails, :public_ids => %w(participants))

    produce_one_for_one(:ppg_status_histories, PpgStatusHistory,
      :public_ids => %w(participants)
    )

    produce_one_for_one(:contacts, Contact,
      :column_map => {
        :contact_disposition => :contact_disp,
        :contact_language_code => :contact_lang,
        :contact_language_other => :contact_lang_oth,
        :who_contacted_other => :who_contact_oth
      },
      :ignored_columns => %w(contact_date_date)
    )

    produce_one_for_one(:events, Event,
      :public_ids => [
        { :table => :participants, :public_id => :p_id, :public_ref => :participant_id }
      ],
      :column_map => {
        :event_disposition => :event_disp,
        :event_disposition_category_code => :event_disp_cat,
        :event_incentive_cash => :event_incent_cash,
        :event_incentive_noncash => :event_incent_noncash
      }
    )

    produce_one_for_one(:instruments, Instrument,
      :public_ids => %w(events),
      :column_map => {
        :instrument_start_date => :ins_date_start,
        :instrument_start_time => :ins_start_time,
        :instrument_end_date => :ins_date_end,
        :instrument_end_time => :ins_end_time,
        :instrument_breakoff_code => :ins_breakoff,
        :instrument_status_code => :ins_status,
        :instrument_mode_code => :ins_mode,
        :instrument_mode_other => :ins_mode_oth,
        :instrument_comment => :instru_comment,
        :instrument_method_code => :ins_method,
        :supervisor_review_code => :sup_review
      },
      :ignored_columns => %w(person_id survey_id)
    )

    produce_one_for_one(:contact_links, LinkContact,
      :public_ids => [
        { :table => :people, :join_column => :person_id },
        :events,
        :contacts,
        :instruments
      ]
    )

    produce_one_for_one(:addresses, Address,
      :public_ids => [
        { :table => :people, :join_column => :person_id },
        { :table => :dwelling_units, :public_id => :du_id }
      ],
      :column_map => {
        :address_one => :address_1,
        :address_two => :address_2
      },
      :ignored_columns => %w(address_start_date_date address_end_date_date)
    )

    produce_one_for_one(:emails, Email,
      :public_ids => [
        { :table => :people, :join_column => :person_id },
      ],
      :ignored_columns => %w(email_start_date_date email_end_date_date)
    )

    produce_one_for_one(:telephones, Telephone,
      :public_ids => [
        { :table => :people, :join_column => :person_id },
      ],
      :ignored_columns => %w(phone_start_date_date phone_end_date_date)
    )
  end
end
