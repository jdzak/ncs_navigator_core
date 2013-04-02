# -*- coding: utf-8 -*-

module OperationalDataExtractor
  class InformedConsent < Base

    PARTICIPANT_CONSENT_MAP = {
      "consent_form_type_code"              => "consent_form_type_code",
      "consent_given_code"                  => "consent_given_code",
      "consent_date"                        => "consent_date",
      "consent_version"                     => "consent_version",
      "consent_expiration"                  => "consent_expiration",
      "who_consented_code"                  => "who_consented_code",
      "consent_language_code"               => "consent_language_code",
      "consent_translate_code"              => "consent_translate_code",
      "reconsideration_script_use_code"     => "reconsideration_script_use_code",
      "consent_comments"                    => "consent_comments",
      "consent_withdraw_code"               => "consent_withdraw_code",
      "consent_withdraw_type_code"          => "consent_withdraw_type_code",
      "consent_withdraw_reason_code"        => "consent_withdraw_reason_code",
      "consent_withdraw_date"               => "consent_withdraw_date",
      "who_withdrew_consent"                => "who_wthdrw_consent_code",
      "consent_reconsent_code"              => "consent_reconsent_code",
      "consent_reconsent_reason_code"       => "consent_reconsent_reason_code",
      "consent_reconsent_reason_other"      => "consent_reconsent_reason_other",
    }

    PARTICIPANT_CONSENT_SAMPLE_MAP = {
      "sample_consent_given_code_1"  => "sample_consent_given_code",
      "sample_consent_given_code_2"  => "sample_consent_given_code",
      "sample_consent_given_code_3"  => "sample_consent_given_code",
    }

    def initialize(response_set)
      super(response_set)
    end

    def maps
      [
        PARTICIPANT_CONSENT_MAP,
        PARTICIPANT_CONSENT_SAMPLE_MAP,
      ]
    end

    def extract_data
      consent = response_set.participant_consent
      raise InvalidSurveyException, "No ParticipantConsent record associated with Response Set" unless consent

      PARTICIPANT_CONSENT_MAP.each do |key, attribute|
        if r = data_export_identifier_indexed_responses[key]
          value = response_value(r)
          unless value.blank?
            consent.send("#{attribute}=", value)
          end
        end
      end

      # Set values on the ParticipantConsentSamples
      ParticipantConsentSample::SAMPLE_CONSENT_TYPE_CODES.each do |code|
        samples = consent.participant_consent_samples.where(:sample_consent_type_code => code).all
        # There should be only one - but might as well update all samples associated with this consent
        samples.each do |sample|
          key = "PARTICIPANT_CONSENT_SAMPLE.SAMPLE_CONSENT_GIVEN_CODE_#{code}"
          if r = data_export_identifier_indexed_responses[key]
            value = response_value(r)
            unless value.blank?
              sample.sample_consent_given_code = value
              sample.save!
            end
          end
        end
      end
      update_enrollment_status(consent)

      consent.save!
    end

    ##
    # Either enroll or unenroll the participant based on the
    # recently updated participant consent
    # @param [ParticipantConsent]
    def update_enrollment_status(consent)
      participant = consent.participant
      if consent.consented?
        participant.update_enrollment_status!(true, consent.consent_date) unless participant.enrolled?
      else
        participant.update_enrollment_status!(false)
        create_withdrawn_ppg_status(participant, consent.consent_date)
      end
    end

    ##
    # If the most recent status history is not withdrawn create
    # a PpgStatusHistory record for the participant
    # only if the participant is not a child participant
    def create_withdrawn_ppg_status(participant, date)
      return if participant.child_participant?

      unless participant.ppg_status_histories.first.try(:ppg_status_code) == PpgStatusHistory::WITHDRAWN
        PpgStatusHistory.create(:participant => participant,
                                :psu => participant.psu,
                                :ppg_status_date => date,
                                :ppg_status_code => PpgStatusHistory::WITHDRAWN)
      end
    end
  end

  class InvalidSurveyException < StandardError; end
end