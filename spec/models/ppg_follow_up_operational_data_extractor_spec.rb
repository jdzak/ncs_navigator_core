require 'spec_helper'

describe PpgFollowUpOperationalDataExtractor do
  include SurveyCompletion

  before(:each) do
    create_missing_in_error_ncs_codes(Instrument)
    create_missing_in_error_ncs_codes(Participant)
    create_missing_in_error_ncs_codes(PpgDetail)
    create_missing_in_error_ncs_codes(PpgStatusHistory)
    create_missing_in_error_ncs_codes(Telephone)
    create_missing_in_error_ncs_codes(Email)
    Factory(:ncs_code, :list_name => "PERSON_PARTCPNT_RELTNSHP_CL1", :display_text => "Self", :local_code => 1)

    Factory(:ncs_code, :list_name => "PHONE_TYPE_CL1", :local_code => 1, :display_text => "Home")
    Factory(:ncs_code, :list_name => "PHONE_TYPE_CL1", :local_code => 2, :display_text => "Work")
    Factory(:ncs_code, :list_name => "PHONE_TYPE_CL1", :local_code => 3, :display_text => "Cell")
    Factory(:ncs_code, :list_name => "PHONE_TYPE_CL1", :local_code => -5, :display_text => "Other")
  end

  context "updating the ppg status history" do

    before(:each) do
      @person = Factory(:person)
      @participant = Factory(:participant)
      @ppl = Factory(:participant_person_link, :participant => @participant, :person => @person)
      Factory(:ppg_detail, :participant => @participant)

      @ppg1 = Factory(:ncs_code, :list_name => "PPG_STATUS_CL1", :display_text => "PPG Group 1", :local_code => 1)
      @ppg2 = Factory(:ncs_code, :list_name => "PPG_STATUS_CL1", :display_text => "PPG Group 2", :local_code => 2)
      @ppg3 = Factory(:ncs_code, :list_name => "PPG_STATUS_CL1", :display_text => "PPG Group 3", :local_code => 3)
      @ppg4 = Factory(:ncs_code, :list_name => "PPG_STATUS_CL1", :display_text => "PPG Group 4", :local_code => 4)
      @ppg5 = Factory(:ncs_code, :list_name => "PPG_STATUS_CL1", :display_text => "PPG Group 5", :local_code => 5)

      @survey = create_follow_up_survey_with_ppg_status_history_operational_data
      @response_set, @instrument = @person.start_instrument(@survey)
      @response_set.save!
      @response_set.responses.size.should == 0
      @participant.ppg_status.local_code.should == 2
    end

    it "updates the ppg status to 1 if the person responds that they are pregnant" do
      take_survey(@survey, @response_set) do |a|
        a.choice "#{PpgFollowUpOperationalDataExtractor::INTERVIEW_PREFIX}.PREGNANT", @ppg1
        a.date "#{PpgFollowUpOperationalDataExtractor::INTERVIEW_PREFIX}.PPG_DUE_DATE_1", '2011-12-25'
      end

      @response_set.responses.reload
      @response_set.responses.size.should == 2

      PpgFollowUpOperationalDataExtractor.extract_data(@response_set)

      person  = Person.find(@person.id)
      participant = person.participant
      participant.ppg_status_histories.size.should == 1
      participant.ppg_status_histories.first.ppg_status.local_code.should == 1
      participant.ppg_status.local_code.should == 1
      participant.due_date.should == Date.parse("2011-12-25")
      participant.ppg_details.first.orig_due_date.should == "2011-12-25"
    end

    it "updates the ppg status to 3 if the person responds that they recently lost their child during pregnancy" do
      take_survey(@survey, @response_set) do |a|
        a.choice "#{PpgFollowUpOperationalDataExtractor::INTERVIEW_PREFIX}.PREGNANT", @ppg3
      end

      @response_set.responses.reload
      @response_set.responses.size.should == 1

      PpgFollowUpOperationalDataExtractor.extract_data(@response_set)

      person  = Person.find(@person.id)
      participant = person.participant
      participant.ppg_status_histories.size.should == 1
      participant.ppg_status_histories.first.ppg_status.local_code.should == 3
      participant.ppg_status.local_code.should == 3
      participant.due_date.should be_nil

    end

    it "updates the ppg status to 2 if the person responds that they are trying" do
      take_survey(@survey, @response_set) do |a|
        a.yes "#{PpgFollowUpOperationalDataExtractor::INTERVIEW_PREFIX}.TRYING"
      end

      @response_set.responses.reload
      @response_set.responses.size.should == 1

      PpgFollowUpOperationalDataExtractor.extract_data(@response_set)

      person  = Person.find(@person.id)
      participant = person.participant
      participant.ppg_status_histories.size.should == 1
      participant.ppg_status_histories.first.ppg_status.local_code.should == 2
      participant.ppg_status.local_code.should == 2
      participant.due_date.should be_nil

    end


    it "updates the ppg status to 3 if the person responds that they recently lost their child" do
      take_survey(@survey, @response_set) do |a|
        a.choice "#{PpgFollowUpOperationalDataExtractor::INTERVIEW_PREFIX}.TRYING", @ppg3
      end

      @response_set.responses.reload
      @response_set.responses.size.should == 1

      PpgFollowUpOperationalDataExtractor.extract_data(@response_set)

      person  = Person.find(@person.id)
      participant = person.participant
      participant.ppg_status_histories.size.should == 1
      participant.ppg_status_histories.first.ppg_status.local_code.should == 3
      participant.ppg_status.local_code.should == 3
      participant.due_date.should be_nil

    end


    it "updates the ppg status to 4 if the person responds that they recently gave birth" do
      take_survey(@survey, @response_set) do |a|
        a.choice "#{PpgFollowUpOperationalDataExtractor::INTERVIEW_PREFIX}.TRYING", @ppg4
      end

      @response_set.responses.reload
      @response_set.responses.size.should == 1

      PpgFollowUpOperationalDataExtractor.extract_data(@response_set)

      person  = Person.find(@person.id)
      participant = person.participant
      participant.ppg_status_histories.size.should == 1
      participant.ppg_status_histories.first.ppg_status.local_code.should == 4
      participant.ppg_status.local_code.should == 4
      participant.due_date.should be_nil

    end

    it "updates the ppg status to 5 if the person responds that they are medically unable to become pregnant" do
      take_survey(@survey, @response_set) do |a|
        a.yes "#{PpgFollowUpOperationalDataExtractor::INTERVIEW_PREFIX}.MED_UNABLE"
      end

      @response_set.responses.reload
      @response_set.responses.size.should == 1

      PpgFollowUpOperationalDataExtractor.extract_data(@response_set)

      person  = Person.find(@person.id)
      participant = person.participant
      participant.ppg_status_histories.size.should == 1
      participant.ppg_status_histories.first.ppg_status.local_code.should == 5
      participant.ppg_status.local_code.should == 5
      participant.due_date.should be_nil

    end


  end

  it "extracts telephone operational data from the survey responses" do

    home = Factory(:ncs_code, :list_name => "PHONE_TYPE_CL1", :display_text => "Home", :local_code => 1)
    work = Factory(:ncs_code, :list_name => "PHONE_TYPE_CL1", :display_text => "Work", :local_code => 2)
    cell = Factory(:ncs_code, :list_name => "PHONE_TYPE_CL1", :display_text => "Cell", :local_code => 3)
    frre = Factory(:ncs_code, :list_name => "PHONE_TYPE_CL1", :display_text => "Friend/Relative", :local_code => 4)
    oth  = Factory(:ncs_code, :list_name => "PHONE_TYPE_CL1", :display_text => "Other", :local_code => -5)

    person = Factory(:person)
    person.telephones.size.should == 0

    survey = create_follow_up_survey_with_telephone_operational_data
    response_set, instrument = person.start_instrument(survey)
    response_set.save!
    response_set.responses.size.should == 0

    take_survey(survey, response_set) do |a|
      a.str "#{PpgFollowUpOperationalDataExtractor::INTERVIEW_PREFIX}.PHONE_NBR", '3125551234'
      a.choice "#{PpgFollowUpOperationalDataExtractor::INTERVIEW_PREFIX}.PHONE_TYPE", cell
    end

    response_set.responses.reload
    response_set.responses.size.should == 2

    PpgFollowUpOperationalDataExtractor.extract_data(response_set)

    person  = Person.find(person.id)
    person.telephones.size.should == 1
    telephone = person.telephones.first
    telephone.phone_type.local_code.should == 3
    telephone.phone_nbr.should == "3125551234"

  end


  it "extracts contact data from the SAQ survey responses" do
    home = Factory(:ncs_code, :list_name => "PHONE_TYPE_CL1", :display_text => "Home", :local_code => 1)
    work = Factory(:ncs_code, :list_name => "PHONE_TYPE_CL1", :display_text => "Work", :local_code => 2)
    cell = Factory(:ncs_code, :list_name => "PHONE_TYPE_CL1", :display_text => "Cell", :local_code => 3)
    oth  = Factory(:ncs_code, :list_name => "PHONE_TYPE_CL1", :display_text => "Other", :local_code => -5)

    person = Factory(:person)
    person.telephones.size.should == 0
    person.emails.size.should == 0

    survey = create_follow_up_survey_with_contact_operational_data
    response_set, instrument = person.start_instrument(survey)
    response_set.save!
    response_set.responses.size.should == 0

    take_survey(survey, response_set) do |a|
      a.str "#{PpgFollowUpOperationalDataExtractor::SAQ_PREFIX}.HOME_PHONE", '3125551234'
      a.str "#{PpgFollowUpOperationalDataExtractor::SAQ_PREFIX}.CELL_PHONE", '3125555678'
      a.str "#{PpgFollowUpOperationalDataExtractor::SAQ_PREFIX}.WORK_PHONE", '3125559012'
      a.str "#{PpgFollowUpOperationalDataExtractor::SAQ_PREFIX}.OTHER_PHONE", '3125553456'
      a.str "#{PpgFollowUpOperationalDataExtractor::SAQ_PREFIX}.EMAIL", 'email@dev.null'
    end

    response_set.responses.reload
    response_set.responses.size.should == 5

    PpgFollowUpOperationalDataExtractor.extract_data(response_set)

    person  = Person.find(person.id)

    person.telephones.size.should == 4
    person.telephones.each do |t|
      t.phone_type.should_not be_nil
      t.phone_nbr[0,6].should == "312555"
    end

    person.emails.size.should == 1
    person.emails.first.email.should == "email@dev.null"
    person.emails.first.email_type.local_code.should == -4

  end

end
