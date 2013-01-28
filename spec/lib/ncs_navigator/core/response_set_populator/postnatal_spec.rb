# -*- coding: utf-8 -*-

require 'spec_helper'

module NcsNavigator::Core

  describe ResponseSetPopulator::Postnatal do
    include SurveyCompletion

    def get_response_as_string(response_set, reference_identifier)
      response = response_set.responses.select { |r|
        r.question.reference_identifier == reference_identifier
      }.first
      response.to_s
    end

    def init_common_vars
      @participant = Factory(:participant)
      @person = Factory(:person)
      @participant.person = @person
      @participant.save!
      @response_set, @instrument = prepare_instrument(@person, @participant,
                                                      @survey)
      @response_set.responses.should be_empty
    end

    def prepare_and_take_survey(question_dexp_identifier, answer,
                                survey_template, event=nil)
      survey = send(survey_template)
      response_set, instrument = prepare_instrument(@person, @participant,
                                                    survey)
      response_set.responses.should be_empty

      answer_code = mock(NcsCode, :local_code => answer)
      take_survey(survey, response_set) do |a|
        a.choice(question_dexp_identifier, answer_code)
      end
    end

    def make_contact(event_type_code, event_complete = '2010-12-12')
      event = Factory(:event, :event_type_code => event_type_code,
                      :event_end_date => event_complete,
                      :participant => @participant)
      contact = Factory(:contact)
      contact_link = Factory(:contact_link, :person => @person, 
                              :contact => contact, :event => event)
      ncs_code = NcsCode::for_list_name_and_local_code('EVENT_TYPE_CL1',
                                                        event_type_code)
      @person.participant.completed_event?(ncs_code).send(
        event_complete ? :should : :should_not) == true
    end

    context "for 3MM child habits prepopulators"
      describe "prepopulated_is_birth_deliver_collelected_and_set_to_one" do
        before(:each) do
          @survey = create_generic_true_false_prepopulator_survey(
                      "INS_QUE_3Month_INT_EHPBHILIPBS_M3.1_V2.0_CHILD_HABITS",
                      "prepopulated_is_birth_deliver_collelected_and_set_to_one")
          init_common_vars
        end

        it "should be TRUE when a birth was given at a hospital" do
          prepare_and_take_survey('BIRTH_VISIT_LI_2.BIRTH_DELIVER',
                                  1, :create_birth_part_one_birth_deliver)
          rsp = ResponseSetPopulator::Postnatal.new(@person, @instrument,
                                                    @survey)
          get_response_as_string(rsp.populate,
            "prepopulated_is_birth_deliver_collelected_and_set_to_one"
          ).should == "TRUE"
        end
        it "should be FALSE when a birth was not given at a hospital" do
          prepare_and_take_survey('BIRTH_VISIT_LI_2.BIRTH_DELIVER',
                                  2, :create_birth_part_one_birth_deliver)
          rsp = ResponseSetPopulator::Postnatal.new(@person, @instrument,
                                                    @survey)
          get_response_as_string(rsp.populate,
            "prepopulated_is_birth_deliver_collelected_and_set_to_one"
          ).should == "FALSE"
        end
        it "should be FALSE when information about birth was not collected" do
          rsp = ResponseSetPopulator::Postnatal.new(@person, @instrument,
                                                    @survey)
          get_response_as_string(rsp.populate,
            "prepopulated_is_birth_deliver_collelected_and_set_to_one"
          ).should == "FALSE"
        end
      end

      describe "prepopulated_is_prev_event_birth_li_and_set_to_complete" do
        before(:each) do
          @survey = create_generic_true_false_prepopulator_survey(
                      "INS_QUE_3Month_INT_EHPBHILIPBS_M3.1_V2.0_CHILD_HABITS",
                      "prepopulated_is_prev_event_birth_li_and_set_to_complete")
          init_common_vars
        end

        it "should be TRUE when a complete birth record exists" do
          make_contact(Event::birth_code)
          rsp = ResponseSetPopulator::Postnatal.new(@person, @instrument,
                                                    @survey)
          get_response_as_string(rsp.populate,
            "prepopulated_is_prev_event_birth_li_and_set_to_complete"
          ).should == "TRUE"
        end

        it "should be FALSE when an incomplete birth record exists" do
          make_contact(Event::birth_code, event_complete = nil)
          rsp = ResponseSetPopulator::Postnatal.new(@person, @instrument,
                                                    @survey)
          get_response_as_string(rsp.populate,
            "prepopulated_is_prev_event_birth_li_and_set_to_complete"
          ).should == "FALSE"
        end
        it "should be FALSE when no birth record exists" do
          rsp = ResponseSetPopulator::Postnatal.new(@person, @instrument,
                                                    @survey)
          get_response_as_string(rsp.populate,
            "prepopulated_is_prev_event_birth_li_and_set_to_complete"
          ).should == "FALSE"
        end
      end

      describe "prepopulated_is_multiple_child" do
        def have_children(quantity)
          mother = @participant
          child_code = NcsCode::for_list_name_and_display_text(
                                          "PERSON_PARTCPNT_RELTNSHP_CL1",
                                          "Child").local_code
          mother_code = NcsCode::for_list_name_and_display_text(
                                          "PERSON_PARTCPNT_RELTNSHP_CL1",
                                          "Biological Mother").local_code
          (1..quantity).each do
            child = Factory(:participant)
            child.person = Factory(:person)
            ParticipantPersonLink.create(:person_id => child.person.id,
                                        :participant_id => mother.id,
                                        :relationship_code => child_code)
            ParticipantPersonLink.create(:person_id => mother.person.id,
                                        :participant_id => child.id,
                                        :relationship_code => mother_code)
            child.save!
          end
        end
          
        before(:each) do
          @survey = create_generic_true_false_prepopulator_survey(
                      "INS_QUE_3Month_INT_EHPBHILIPBS_M3.1_V2.0_CHILD_HABITS",
                      "prepopulated_is_multiple_child")
          init_common_vars
        end

        it "should be TRUE when participant has multiple children" do
          have_children(2)
          rsp = ResponseSetPopulator::Postnatal.new(@person, @instrument,
                                                    @survey)
          get_response_as_string(rsp.populate,
                            "prepopulated_is_multiple_child").should == "TRUE"
        end

        it "should be FALSE when participant has only one child" do
          have_children(1)
          rsp = ResponseSetPopulator::Postnatal.new(@person, @instrument,
                                                    @survey)
          get_response_as_string(rsp.populate,
                            "prepopulated_is_multiple_child").should == "FALSE"
        end

        it "should be TRUE when participant has no children" do
          rsp = ResponseSetPopulator::Postnatal.new(@person, @instrument,
                                                    @survey)
          get_response_as_string(rsp.populate,
                            "prepopulated_is_multiple_child").should == "FALSE"
        end
      end

    context "for 3MM part two prepopulators"
      describe "prepopulated_is_6_month_event" do
        before(:each) do
          @survey = create_generic_true_false_prepopulator_survey(
                      "INS_QUE_3MMother_INT_EHPBHI_P2_V1.1_PART_TWO",
                      "prepopulated_should_show_demographics")
          init_common_vars
        end

        it "should be TRUE when there are no pre-natal events" do
          make_contact(Event::six_month_visit_code)
          rsp = ResponseSetPopulator::Postnatal.new(@person, @instrument,
                                                    @survey)
          get_response_as_string(rsp.populate,
                       "prepopulated_should_show_demographics").should == "TRUE"
        end

        it "should be FALSE when there are pre-natal events" do
          make_contact(Event::pregnancy_visit_1_code)
          rsp = ResponseSetPopulator::Postnatal.new(@person, @instrument,
                                                    @survey)
          get_response_as_string(rsp.populate,
                       "prepopulated_should_show_demographics").should == "FALSE"
        end
      end

    context "for 18MM v2.x prepopulators"
      describe "prepopulated_should_show_upper_arm_length" do
        before(:each) do
          @survey = create_generic_true_false_prepopulator_survey(
              "INS_QUE_18MMother_INT_EHPBHI_M2.2_V2.0_EIGHTEEN_MTH_MOTHER_MOLD",
              "prepopulated_should_show_room_mold_child")
          init_common_vars
          @rsp = ResponseSetPopulator::Postnatal.new(@person, @instrument,
                                                     @survey)
        end

        it "should be TRUE if response to MOLD question was YES" do
          prepare_and_take_survey("EIGHTEEN_MTH_MOTHER_2.MOLD", 1,
                      :create_18mm_v2_survey_part_three_for_mold_prepopulators)
          get_response_as_string(@rsp.populate,
                        "prepopulated_should_show_room_mold_child"
                      ).should == "TRUE"
        end
        it "should be FALSE if response to MOLD question was NO" do
          prepare_and_take_survey("EIGHTEEN_MTH_MOTHER_2.MOLD", 2,
                      :create_18mm_v2_survey_part_three_for_mold_prepopulators)
          get_response_as_string(@rsp.populate,
                        "prepopulated_should_show_room_mold_child"
                      ).should == "FALSE"
        end

        it "should be FALSE if response to MOLD question was REFUSED" do
          prepare_and_take_survey("EIGHTEEN_MTH_MOTHER_2.MOLD", "neg_1",
                      :create_18mm_v2_survey_part_three_for_mold_prepopulators)
          get_response_as_string(@rsp.populate,
                        "prepopulated_should_show_room_mold_child"
                      ).should == "FALSE"
        end
        it "should be FALSE if response to MOLD question was REFUSED" do
          prepare_and_take_survey("EIGHTEEN_MTH_MOTHER_2.MOLD", "neg_2",
                      :create_18mm_v2_survey_part_three_for_mold_prepopulators)
          get_response_as_string(@rsp.populate,
                        "prepopulated_should_show_room_mold_child"
                      ).should == "FALSE"
        end
        it "should be FALSE if 18MM part 3 survey was not completed" do
          get_response_as_string(@rsp.populate,
                        "prepopulated_should_show_room_mold_child"
                      ).should == "FALSE"
        end
      end

  end
end
