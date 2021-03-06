module ResponseSetPrepopulation
  class NonInterview < Populator
    include OldAccessMethods

    def self.applies_to?(rs)
      rs.survey.title.include?('_NonIntRespQues_')
    end

    def self.reference_identifiers
      [
        "prepopulated_is_declined_participation_prior_to_enrollment",
        "prepopulated_study_center_type"
      ]
    end

    def run
      self.class.reference_identifiers.each do |reference_identifier|
        if question = find_question_for_reference_identifier(
                                              reference_identifier)
          response_type = "answer"
          answer =
            case reference_identifier
            when "prepopulated_is_declined_participation_prior_to_enrollment"
              consent_given?(question)
            when "prepopulated_study_center_type"
              what_study_center_type?(question)
            else
              nil
            end

          build_response_for_value(response_type, response_set,
                                   question, answer, nil)
        end
      end
      response_set
    end

    def consent_given?(question)
      answer_for(question, participant.consented?)
    end

    def what_study_center_type?(question)
      # Maps answer.text to answer.reference_identifier for clarity
      answer_map = {
        "OVC AND EH STUDY CENTER" => 1,
        "PB AND PBS STUDY CENTER" => 2,
        "HILI STUDY CENTER" => 3
      }

      # Maps recruitment_type_id to the corresponding answer.reference_identifier
      center_type_map = {
        # Enhanced Household Enumeration
        1 => answer_map["OVC AND EH STUDY CENTER"],
        # Provider-Based Recruitment
        2 => answer_map["PB AND PBS STUDY CENTER"],
        # Two-Tier
        3 => answer_map["HILI STUDY CENTER"],
        # Original VC
        4 => answer_map["OVC AND EH STUDY CENTER"],
        # Provider Based Subsample
        5 => answer_map["PB AND PBS STUDY CENTER"]
      }

      answer_for(question, center_type_map[NcsNavigatorCore.recruitment_type_id])
    end
  end
end
