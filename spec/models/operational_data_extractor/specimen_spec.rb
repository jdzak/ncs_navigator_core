# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: specimens
#
#  created_at             :datetime
#  data_export_identifier :string(255)
#  id                     :integer          not null, primary key
#  instrument_id          :integer
#  response_set_id        :integer
#  specimen_id            :string(36)       not null
#  specimen_pickup_id     :integer
#  updated_at             :datetime
#



require 'spec_helper'

describe OperationalDataExtractor do
  describe "::extractor_for" do
    let(:person) { Factory(:person) }
    let(:participant) { Factory(:participant) }

    it "returns OperationalDataExtractor of type Specimen" do
      SamplesAndSpecimens.instance_methods.select{|m| m.to_s =~ /^create.*specimen_operational_data/}.each do |m|
        survey = send(m)
        response_set, instrument = prepare_instrument(person, participant, survey)

        handler = OperationalDataExtractor::Base.extractor_for(response_set)
        handler.instance_of?(OperationalDataExtractor::Specimen).should be(true)

      end
    end
  end
end

describe OperationalDataExtractor::Specimen do
  include SurveyCompletion

  describe ".extract_data" do

    let(:person) { Factory(:person) }
    let(:participant) { Factory(:participant) }

    context "the adult urine collection instrument" do
      it "creates a sample from the instrument response" do
        survey = create_adult_urine_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        expected = 'AA1234567-UR01'

        take_survey(survey, response_set) do |r|
          r.a "SPEC_URINE.SPECIMEN_ID", expected
        end

        response_set.responses.reload
        response_set.responses.size.should == 1

        OperationalDataExtractor::Specimen.new(response_set).extract_data

        specimens = Specimen.where(:instrument_id => instrument.id).all
        specimens.should_not be_blank
        specimens.size.should == 1
        specimens.first.specimen_id.should == expected
      end

      it "raises an exception if there is no instrument associated with the response_set" do
        mock_response_set = mock(ResponseSet, :instrument => nil)
        expect { OperationalDataExtractor::Specimen.extract_data(mock_response_set) }.to raise_error
      end

    end

    context "the adult blood collection instrument" do
      it "creates up to 6 specimens from the instrument response" do
        survey = create_adult_blood_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        specimen_ids = [
          "AA123456-SS10",
          "AA123456-RD10",
          "AA123456-PP10",
          "AA123456-LV10",
          "AA123456-PN10",
          "AA123456-AD10",
        ]

        take_survey(survey, response_set) do |r|
          r.a "SPEC_BLOOD_TUBE[tube_type=1].SPECIMEN_ID", specimen_ids[0]
          r.a "SPEC_BLOOD_TUBE[tube_type=2].SPECIMEN_ID", specimen_ids[1]
          r.a "SPEC_BLOOD_TUBE[tube_type=3].SPECIMEN_ID", specimen_ids[2]
          r.a "SPEC_BLOOD_TUBE[tube_type=4].SPECIMEN_ID", specimen_ids[3]
          r.a "SPEC_BLOOD_TUBE[tube_type=5].SPECIMEN_ID", specimen_ids[4]
          r.a "SPEC_BLOOD_TUBE[tube_type=6].SPECIMEN_ID", specimen_ids[5]
        end

        response_set.responses.reload
        response_set.responses.size.should == 6

        OperationalDataExtractor::Specimen.new(response_set).extract_data

        instrument.specimens.reload
        instrument.specimens.count.should == 6

        specimen_ids.each do |specimen_id|
          instrument.specimens.where(:specimen_id => specimen_id).first.should_not be_nil
        end

      end

      it "creates only the number of specimens as there are related responses" do
        survey = create_adult_blood_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        specimen_ids = [
          "AA123456-SS10",
        ]

        take_survey(survey, response_set) do |r|
          r.a "SPEC_BLOOD_TUBE[tube_type=1].SPECIMEN_ID", specimen_ids[0]
        end

        response_set.responses.reload
        response_set.responses.size.should == 1

        OperationalDataExtractor::Specimen.new(response_set).extract_data

        instrument.specimens.reload
        instrument.specimens.count.should == 1

        specimen_ids.each do |specimen_id|
          instrument.specimens.where(:specimen_id => specimen_id).first.should_not be_nil
        end

      end

      it "updates existing records instead of creating new ones" do
        survey = create_adult_blood_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        specimen_ids = [
          "AA123456-SS10",
          "AA123456-RD10",
          "AA123456-PP10",
          "AA123456-LV10",
        ]

        take_survey(survey, response_set) do |r|
          r.a "SPEC_BLOOD_TUBE[tube_type=1].SPECIMEN_ID", specimen_ids[0]
          r.a "SPEC_BLOOD_TUBE[tube_type=2].SPECIMEN_ID", specimen_ids[1]
          r.a "SPEC_BLOOD_TUBE[tube_type=3].SPECIMEN_ID", specimen_ids[2]
          r.a "SPEC_BLOOD_TUBE[tube_type=4].SPECIMEN_ID", specimen_ids[3]
        end

        response_set.responses.reload
        response_set.responses.size.should == 4

        OperationalDataExtractor::Specimen.new(response_set).extract_data

        instrument.specimens.reload
        instrument.specimens.count.should == 4

        specimen_ids.each do |specimen_id|
          instrument.specimens.where(:specimen_id => specimen_id).first.should_not be_nil
        end

        update_specimen_ids = [
          "AA999999-SS10",
          "AA999999-RD10",
          "AA999999-PP10",
          "AA999999-LV10",
          "AA999999-PN10",
          "AA999999-AD10",
        ]

        take_survey(survey, response_set) do |r|
          r.a "SPEC_BLOOD_TUBE[tube_type=1].SPECIMEN_ID", update_specimen_ids[0]
          r.a "SPEC_BLOOD_TUBE[tube_type=2].SPECIMEN_ID", update_specimen_ids[1]
          r.a "SPEC_BLOOD_TUBE[tube_type=3].SPECIMEN_ID", update_specimen_ids[2]
          r.a "SPEC_BLOOD_TUBE[tube_type=4].SPECIMEN_ID", update_specimen_ids[3]
          r.a "SPEC_BLOOD_TUBE[tube_type=5].SPECIMEN_ID", update_specimen_ids[4]
          r.a "SPEC_BLOOD_TUBE[tube_type=6].SPECIMEN_ID", update_specimen_ids[5]
        end

        response_set.responses.reload
        response_set.responses.size.should == 10

        OperationalDataExtractor::Specimen.new(response_set).extract_data

        instrument.specimens.reload
        instrument.specimens.count.should == 6

        instrument.specimens.collect(&:specimen_id).sort.should == update_specimen_ids.sort

      end

    end


    context "the cord blood collection instrument" do
      it "creates up to 3 specimens from the instrument response" do
        survey = create_cord_blood_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        specimen_ids = [
          "AA123456-CL01",
          "AA123456-CS01",
          "AA123456-CB01",
        ]

        take_survey(survey, response_set) do |r|
          r.a "SPEC_CORD_BLOOD_SPECIMEN[cord_container=1].SPECIMEN_ID", specimen_ids[0]
          r.a "SPEC_CORD_BLOOD_SPECIMEN[cord_container=2].SPECIMEN_ID", specimen_ids[1]
          r.a "SPEC_CORD_BLOOD_SPECIMEN[cord_container=3].SPECIMEN_ID", specimen_ids[2]
        end

        response_set.responses.reload
        response_set.responses.size.should == 3

        OperationalDataExtractor::Specimen.new(response_set).extract_data

        instrument.specimens.reload
        instrument.specimens.count.should == 3

        specimen_ids.each do |specimen_id|
          instrument.specimens.where(:specimen_id => specimen_id).first.should_not be_nil
        end

      end
      
      it "creates up to 3 specimens from the instrument response for MDES 2.1" do
        survey = create_cord_blood_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        specimen_ids = [
          "AA123456-CL02",
          "AA123456-CS02",
          "AA123456-CB02",
        ]

        take_survey(survey, response_set) do |r|
          r.a "SPEC_CORD_BLOOD_SPECIMEN_2[collection_type=1].SPECIMEN_ID", specimen_ids[0]
          r.a "SPEC_CORD_BLOOD_SPECIMEN_2[collection_type=2].SPECIMEN_ID", specimen_ids[1]
          r.a "SPEC_CORD_BLOOD_SPECIMEN_2[collection_type=3].SPECIMEN_ID", specimen_ids[2]
        end

        response_set.responses.reload
        response_set.responses.size.should == 3

        OperationalDataExtractor::Specimen.new(response_set).extract_data

        instrument.specimens.reload
        instrument.specimens.count.should == 3

        specimen_ids.each do |specimen_id|
          instrument.specimens.where(:specimen_id => specimen_id).first.should_not be_nil
        end

      end
      
      it "creates up to 3 specimens from the instrument response for MDES 2.2" do
        survey = create_cord_blood_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        specimen_ids = [
          "AA123456-CL03",
          "AA123456-CS03",
          "AA123456-CB03",
        ]

        take_survey(survey, response_set) do |r|
          r.a "SPEC_CORD_BLOOD_SPECIMEN_3[collection_type=1].SPECIMEN_ID", specimen_ids[0]
          r.a "SPEC_CORD_BLOOD_SPECIMEN_3[collection_type=2].SPECIMEN_ID", specimen_ids[1]
          r.a "SPEC_CORD_BLOOD_SPECIMEN_3[collection_type=3].SPECIMEN_ID", specimen_ids[2]
        end

        response_set.responses.reload
        response_set.responses.size.should == 3

        OperationalDataExtractor::Specimen.new(response_set).extract_data

        instrument.specimens.reload
        instrument.specimens.count.should == 3

        specimen_ids.each do |specimen_id|
          instrument.specimens.where(:specimen_id => specimen_id).first.should_not be_nil
        end

      end

      it "creates only the number of specimens as there are related responses" do
        survey = create_cord_blood_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        specimen_ids = [
          "AA123456-CB01",
        ]

        take_survey(survey, response_set) do |r|
          r.a "SPEC_CORD_BLOOD_SPECIMEN[cord_container=1].SPECIMEN_ID", specimen_ids[0]
        end

        response_set.responses.reload
        response_set.responses.size.should == 1

        OperationalDataExtractor::Specimen.new(response_set).extract_data

        instrument.specimens.reload
        instrument.specimens.count.should == 1

        specimen_ids.each do |specimen_id|
          instrument.specimens.where(:specimen_id => specimen_id).first.should_not be_nil
        end

      end

    end
    context "the child blood collection instruments" do
      it "creates up to 4 specimens from the instrument response" do
        survey = create_child_blood_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        specimen_ids = [
          "AA1212122-LV20",
          "AA1212122-RD20",
          "AA1212122-RD21",
          "AA1212122-LV21",
        ]

        take_survey(survey, response_set) do |r|
          r.a "CHILD_BLOOD_TUBE[tube_type=1].SPECIMEN_ID", specimen_ids[0]
          r.a "CHILD_BLOOD_TUBE[tube_type=2].SPECIMEN_ID", specimen_ids[1]
          r.a "CHILD_BLOOD_TUBE[tube_type=3].SPECIMEN_ID", specimen_ids[2]
          r.a "CHILD_BLOOD_TUBE[tube_type=4].SPECIMEN_ID", specimen_ids[3]
        end

        response_set.responses.reload
        response_set.responses.size.should == 4

        handler = OperationalDataExtractor::Base.extractor_for(response_set)
        handler.extract_data

        instrument.specimens.reload
        instrument.specimens.count.should == 4

        specimen_ids.each do |specimen_id|
          instrument.specimens.where(:specimen_id => specimen_id).first.should_not be_nil
        end

      end
    end
    context "the child saliva instruments" do
      it "creates specimen from the instrument response" do
        survey = create_child_saliva_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        specimen_ids = [
          "AA1212122-SC12"
        ]

        take_survey(survey, response_set) do |r|
          r.a "CHILD_SALIVA.SPECIMEN_ID", specimen_ids[0]
        end

        response_set.responses.reload
        response_set.responses.size.should == 1

        OperationalDataExtractor::Base.extractor_for(response_set).extract_data

        instrument.specimens.reload
        instrument.specimens.count.should == 1

        specimen_ids.each do |specimen_id|
          instrument.specimens.where(:specimen_id => specimen_id).first.should_not be_nil
        end

      end
    end
    context "the child urine instruments" do
      it "creates specimen from the instrument response" do
        survey = create_child_urine_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        specimen_ids = [
          "AA1212122-BU12"
        ]

        take_survey(survey, response_set) do |r|
          r.a "CHILD_URINE.SPECIMEN_ID", specimen_ids[0]
        end

        response_set.responses.reload
        response_set.responses.size.should == 1

        OperationalDataExtractor::Base.extractor_for(response_set).extract_data

        instrument.specimens.reload
        instrument.specimens.count.should == 1

        specimen_ids.each do |specimen_id|
          instrument.specimens.where(:specimen_id => specimen_id).first.should_not be_nil
        end

      end
    end
    context "the breast milk instruments" do
      it "creates specimen from the instrument response" do
        survey = create_breast_milk_survey_with_specimen_operational_data
        response_set, instrument = prepare_instrument(person, participant, survey)
        specimen_ids = [
          "AA1212122-BM12"
        ]

        take_survey(survey, response_set) do |r|
          r.a "BREAST_MILK_SAQ.SPECIMEN_ID", specimen_ids[0]
        end

        response_set.responses.reload
        response_set.responses.size.should == 1

        OperationalDataExtractor::Base.extractor_for(response_set).extract_data

        instrument.specimens.reload
        instrument.specimens.count.should == 1

        specimen_ids.each do |specimen_id|
          instrument.specimens.where(:specimen_id => specimen_id).first.should_not be_nil
        end

      end
    end
  end

end
