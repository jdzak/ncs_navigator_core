# -*- coding: utf-8 -*-


require 'spec_helper'

describe OperationalDataExtractor::Base do

  it "sets up the test properly" do

    person = Factory(:person)
    survey = create_pregnancy_screener_survey_with_person_operational_data

    survey.sections.size.should == 1
    survey.sections.first.questions.size.should == 9

    survey.sections.first.questions.each do |q|
      case q.reference_identifier
      when "R_FNAME", "R_LNAME", "AGE", "PERSON_DOB"
        q.answers.size.should == 3
      when "AGE_RANGE"
        q.answers.size.should == 9
      when "ETHNICITY"
        q.answers.size.should == 2
      when "PERSON_LANG"
        q.answers.size.should == 3
      when "PERSON_LANG_OTH"
        q.answers.size.should == 1
      end
    end

  end

  describe "determining the proper data extractor to use" do
    let(:person) { Factory(:person) }
    let(:participant) { Factory(:participant) }

    context "with a pregnancy screener instrument" do
      it "chooses the OperationalDataExtractor::PregnancyScreener" do
        survey = create_pregnancy_screener_survey_with_ppg_detail_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        handler = OperationalDataExtractor::Base.extractor_for(response_set)
        handler.class.should == OperationalDataExtractor::PregnancyScreener
      end
    end

    context "with a pregnancy probability instrument" do
      it "chooses the OperationalDataExtractor::PpgFollowUp" do
        survey = create_follow_up_survey_with_ppg_status_history_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        handler = OperationalDataExtractor::Base.extractor_for(response_set)
        handler.class.should == OperationalDataExtractor::PpgFollowUp
      end
    end

    context "with a pre pregnancy instrument" do
      it "chooses the OperationalDataExtractor::PrePregnancy" do
        survey = create_pre_pregnancy_survey_with_person_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        handler = OperationalDataExtractor::Base.extractor_for(response_set)
        handler.class.should == OperationalDataExtractor::PrePregnancy
      end
    end

    context "with a pregnancy visit instrument" do
      it "chooses the OperationalDataExtractor::PregnancyVisit" do
        survey = create_pregnancy_visit_1_survey_with_person_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        handler = OperationalDataExtractor::Base.extractor_for(response_set)
        handler.class.should == OperationalDataExtractor::PregnancyVisit
      end
    end

    context "with a birth visit instrument" do
      it "chooses the OperationalDataExtractor::Birth" do
        survey = create_birth_survey_with_child_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        handler = OperationalDataExtractor::Base.extractor_for(response_set)
        handler.class.should == OperationalDataExtractor::Birth
      end
    end

    context "with a lo i pregnancy screener instrument" do
      it "chooses the OperationalDataExtractor::LowIntensityPregnancyVisit" do
        survey = create_li_pregnancy_screener_survey_with_ppg_status_history_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        handler = OperationalDataExtractor::Base.extractor_for(response_set)
        handler.class.should == OperationalDataExtractor::LowIntensityPregnancyVisit
      end
    end

    context "with an adult blood instrument" do
      it "chooses the OperationalDataExtractor::Specimen" do
        survey = create_adult_blood_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        handler = OperationalDataExtractor::Base.extractor_for(response_set)
        handler.class.should == OperationalDataExtractor::Specimen
      end
    end

    context "with an adult urine instrument" do
      it "chooses the OperationalDataExtractor::Specimen" do
        survey = create_adult_urine_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        handler = OperationalDataExtractor::Base.extractor_for(response_set)
        handler.class.should == OperationalDataExtractor::Specimen
      end
    end

    context "with a cord blood instrument" do
      it "chooses the OperationalDataExtractor::Specimen" do
        survey = create_cord_blood_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        handler = OperationalDataExtractor::Base.extractor_for(response_set)
        handler.class.should == OperationalDataExtractor::Specimen
      end
    end

    context "with a tap water instrument" do
      it "chooses the OperationalDataExtractor::Sample" do
        survey = create_tap_water_survey_with_sample_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        handler = OperationalDataExtractor::Base.extractor_for(response_set)
        handler.class.should == OperationalDataExtractor::Sample
      end
    end

    context "with a vacuum bag dust instrument" do
      it "chooses the OperationalDataExtractor::Sample" do
        survey = create_vacuum_bag_dust_survey_with_sample_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        handler = OperationalDataExtractor::Base.extractor_for(response_set)
        handler.class.should == OperationalDataExtractor::Sample
      end
    end

  end

  context "processing the response set" do

    before(:each) do
      @person = Factory(:person)
      @participant = Factory(:participant)
      @survey = create_pregnancy_screener_survey_with_ppg_detail_operational_data
      @response_set, @instrument = prepare_instrument(@person, @participant, @survey)
      question = Factory(:question, :data_export_identifier => "PREG_SCREEN_HI_2.HOME_PHONE")
      answer = Factory(:answer, :response_class => "string")
      home_phone_response = Factory(:response, :string_value => "3125551212", :question => question, :answer => answer, :response_set => @response_set)

      @response_set.responses << home_phone_response
    end

    describe "#process" do

      before(:each) do
        OperationalDataExtractor::Base.process(@response_set)
      end

      it "creates only one data record for the extracted data" do
        person = Person.find(@person.id)
        phones = person.telephones
        phones.should_not be_empty
        phones.size.should == 1
        phones.first.phone_nbr.should == "3125551212"

        OperationalDataExtractor::Base.process(@response_set)
        person = Person.find(@person.id)
        person.telephones.should == phones
        person.telephones.first.phone_nbr.should == "3125551212"
      end

      it "updates one data record if re-processed" do
        person = Person.find(@person.id)
        phones = person.telephones
        phones.should_not be_empty
        phones.size.should == 1
        phones.first.phone_nbr.should == "3125551212"

        @response_set.responses.first.string_value = "3125556789"

        OperationalDataExtractor::Base.process(@response_set)
        person = Person.find(@person.id)
        person.telephones.should == phones
        person.telephones.first.phone_nbr.should == "3125556789"
      end
    end
  end

  context "processing addresses" do

    before do
      @person = Factory(:person)
      @rs = Factory(:response_set)
      @rs.person = @person
      @ode = OperationalDataExtractor::Base.new(@rs)
    end

    describe "#finalize_addresses" do
      before do
        @existing_business_address = Factory(:address, :address_rank_code => 1, :address_type_code => 2)
        @existing_school_address   = Factory(:address, :address_rank_code => 1, :address_type_code => 3)
        @new_business_address = Factory(:address, :address_rank_code => 4, :address_type_code => 2)
        @new_school_address   = Factory(:address, :address_rank_code => 4, :address_type_code => 3)
        @new_addresses = [ @new_business_address, @new_school_address]
        @person.addresses = [@existing_business_address, @existing_school_address]
      end

      it "demotes exisiting address in favor of new addresses of the same type" do
        @ode.finalize_addresses(@new_addresses)
        @existing_business_address.address_rank_code.should == 2
        @existing_school_address.address_rank_code.should   == 2
      end
    end

    describe "#which_addresses_changed" do
      before do
        @unchanged_address = Factory(:address, :state_code => -4)
        @changed_business_address = Factory(:address, :address_rank_code => 4, :address_type_code => 2)
        @changed_school_address   = Factory(:address, :address_rank_code => 4, :address_type_code => 3)
        @addresses = [@unchanged_address, @changed_business_address, @changed_school_address]
      end

      it "filters out a set of addresses with changed information" do
        @ode.which_addresses_changed(@addresses).should include(@changed_business_address, @changed_school_address)
        @ode.which_addresses_changed(@addresses).should_not include(@unchanged_address)
      end

      describe "process_birth_address" do

        before do
          @map = OperationalDataExtractor::PbsEligibilityScreener::ADDRESS_MAP
          @participant = Factory(:participant)
          @survey = create_pbs_eligibility_screener_survey_with_address_operational_data
          @response_set, @instrument = prepare_instrument(@person, @participant, @survey)

          question = Factory(:question, :data_export_identifier => "PBS_ELIG_SCREENER.ADDRESS_1")
          answer = Factory(:answer, :response_class => "string")
          address1_response = Factory(:response, :string_value => "1708 Sunbeam Ct", :question => question, :answer => answer, :response_set => @response_set)

          question = Factory(:question, :data_export_identifier => "PBS_ELIG_SCREENER.CITY")
          answer = Factory(:answer, :response_class => "string")
          city_response = Factory(:response, :string_value => "Virginia Beach", :question => question, :answer => answer, :response_set => @response_set)

          question = Factory(:question, :data_export_identifier => "PBS_ELIG_SCREENER.ZIP")
          answer = Factory(:answer, :response_class => "string")
          zip_response = Factory(:response, :string_value => "23456", :question => question, :answer => answer, :response_set => @response_set)

          @response_set.responses << address1_response << city_response << zip_response
          @ode2 = OperationalDataExtractor::PbsEligibilityScreener.new(@response_set)
        end

        it "creates birth address record" do
          birth_address = @ode2.process_birth_address(@map)
          birth_address.class.should == Address
          birth_address.address_rank_code.should == 1
          birth_address.address_type_code.should == -5
          birth_address.address_one.should == "1708 Sunbeam Ct"
          birth_address.city.should == "Virginia Beach"
          birth_address.zip.should == "23456"
          birth_address.address_type_other.should == "Birth"
        end
      end

      describe "get_address" do

        before do
          @person = Factory(:person)
          @response_set = Factory(:response_set)
          @code_address_type = NcsCode.for_list_name_and_local_code('ADDRESS_CATEGORY_CL1', 2)
          @address = Factory(:address,
                             :person => @person,
                             :response_set => @response_set,
                             :address_rank_code => 1,
                             :address_type_code => @code_address_type.local_code)

          @ode2 = OperationalDataExtractor::PbsEligibilityScreener.new(@response_set)
        end

        it "fetches an existing address record" do
          @ode2.get_address(@response_set, @person, @code_address_type).should == @address
        end

        it "creates a new record if it can't find an existing record" do
          @address = nil
          new_address = @ode2.get_address(@response_set, @person, @code_address_type)
          new_address.should_not == @address
          new_address.class.should == Address
        end
      end

    end

  end

end
