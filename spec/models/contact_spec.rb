# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20120629204215
#
# Table name: contacts
#
#  contact_comment         :text
#  contact_date            :string(10)
#  contact_date_date       :date
#  contact_disposition     :integer
#  contact_distance        :decimal(6, 2)
#  contact_end_time        :string(255)
#  contact_id              :string(36)       not null
#  contact_interpret_code  :integer          not null
#  contact_interpret_other :string(255)
#  contact_language_code   :integer          not null
#  contact_language_other  :string(255)
#  contact_location_code   :integer          not null
#  contact_location_other  :string(255)
#  contact_private_code    :integer          not null
#  contact_private_detail  :string(255)
#  contact_start_time      :string(255)
#  contact_type_code       :integer          not null
#  contact_type_other      :string(255)
#  created_at              :datetime
#  id                      :integer          not null, primary key
#  lock_version            :integer          default(0)
#  psu_code                :integer          not null
#  transaction_type        :string(255)
#  updated_at              :datetime
#  who_contacted_code      :integer          not null
#  who_contacted_other     :string(255)
#



require 'spec_helper'

require File.expand_path('../../shared/models/a_time_bounded_task', __FILE__)
require File.expand_path('../../shared/models/an_optimistically_locked_record', __FILE__)

describe Contact do
  it "should create a new instance given valid attributes" do
    c = Factory(:contact)
    c.should_not be_nil
  end


  it { should have_many(:contact_links) }
  it { should have_many(:events).through(:contact_links) }
  it { should have_many(:instruments).through(:contact_links) }
  it { should have_one(:non_interview_provider) }
  it { should have_many(:non_interview_reports) }
  it { should have_one(:participant_visit_record) }
  it { should have_many(:participant_visit_consents) }
  it { should have_many(:participant_consents) }

  it {
    should validate_format_of(:contact_start_time).with('66:66').
      with_message(%q(contact_start_time is invalid ("66:66")))
  }
  it {
    should validate_format_of(:contact_end_time).with('66:66').
      with_message(%q(contact_end_time is invalid ("66:66")))
  }

  it { should validate_numericality_of(:contact_distance) }
  it { should ensure_length_of(:contact_date).is_equal_to(10) }

  it_should_behave_like 'an optimistically locked record' do
    subject { Factory(:contact) }

    def modify(winner, loser)
      winner.contact_type_other = 'winner'
      loser.contact_type_other = 'loser'
    end
  end

  it_should_behave_like 'a time-bounded task', 'contact_end_time', '12:00'

  context "as mdes record" do

    it "sets the public_id to a uuid" do
      c = Factory(:contact)
      c.public_id.should_not be_nil
      c.contact_id.should == c.public_id
      c.contact_id.length.should == 36
    end

    it "uses the ncs_code 'Missing in Error' for all required ncs codes" do

      c = Contact.new
      c.save!

      obj = Contact.first
      obj.contact_type.local_code.should == -4
      obj.contact_language.local_code.should == -4
      obj.contact_interpret.local_code.should == -4
      obj.contact_location.local_code.should == -4
      obj.contact_private.local_code.should == -4
      obj.who_contacted.local_code.should == -4
    end
  end

  context "time format" do
    let(:record) { Factory(:contact) }

    describe '#contact_start_time' do
      let(:time_attribute) { :contact_start_time }
      let(:time_name) { 'Contact start time' }

      it_behaves_like 'an MDES time'
    end

    describe ".contact_end_time=" do
      let(:time_attribute) { :contact_end_time }
      let(:time_name) { 'Contact end time' }

      it_behaves_like 'an MDES time'
    end

  end

  context "contact links and instruments" do

    before(:each) do
      @y = NcsCode.for_list_name_and_local_code('CONFIRM_TYPE_CL2', 1)
      @n = NcsCode.for_list_name_and_local_code('CONFIRM_TYPE_CL2', 2)
      @q = NcsCode.for_list_name_and_local_code('CONFIRM_TYPE_CL2', -4)
    end

    it "knows all contact links associated with this contact" do

      c  = Factory(:contact)
      l1 = Factory(:contact_link, :contact => c)

      c.contact_links.should == [l1]

      l2 = Factory(:contact_link, :contact => c)

      c.contact_links.reload
      c.contact_links.should include(l1)
      c.contact_links.should include(l2)
    end

    it "knows all instruments associated with it" do
      c = Factory(:contact)
      e = Factory(:event)
      pers = Factory(:person)
      part = Factory(:participant)
      rs, i1 = prepare_instrument(pers, part,
          create_li_pregnancy_screener_survey_with_ppg_status_history_operational_data)
      l1 = Factory(:contact_link, :event => e, :contact => c, :instrument => i1, :person => pers)

      e.contact_links.should == [l1]
      e.instruments.should == [i1]

      rs, i2 = prepare_instrument(pers, part,
          create_pre_pregnancy_survey_with_email_operational_data)
      l2 = Factory(:contact_link, :event => e, :contact => c, :instrument => i2, :person => pers)

      i3 = Factory(:instrument)
      l3 = Factory(:contact_link, :event => e, :contact => c, :instrument => i3, :person => pers)

      c.contact_links.reload
      c.instruments.reload
      [l1, l2, l3].each { |ins| c.contact_links.should include(ins) }
      [i1, i2, i3].each { |ins| c.instruments.should include(ins) }
      [i1, i2].each { |ins| c.instruments_with_surveys.should include(ins) }
      [i1.survey.title, i2.survey.title].each { |t| c.instrument_survey_titles.should include(t) }
    end

    describe "auto-completing MDES data" do

      before(:each) do

        @y = NcsCode.for_list_name_and_local_code('CONFIRM_TYPE_CL2', 1)
        @n = NcsCode.for_list_name_and_local_code('CONFIRM_TYPE_CL2', 2)
        @q = NcsCode.for_list_name_and_local_code('CONFIRM_TYPE_CL2', -4)

        @ncs_participant = NcsCode.for_list_name_and_local_code('CONTACTED_PERSON_CL1', 1)

        @telephone = NcsCode.for_list_name_and_local_code('CONTACT_TYPE_CL1', 3)
        @mail      = NcsCode.for_list_name_and_local_code('CONTACT_TYPE_CL1', 2)
        @in_person = NcsCode.for_list_name_and_local_code('CONTACT_TYPE_CL1', 1)

        @survey = create_survey_with_language_and_interpreter_data
        @person = Factory(:person)
        @participant = Factory(:participant)
        @english = NcsCode.for_list_name_and_local_code('LANGUAGE_CL2', 1)
        @spanish = NcsCode.for_list_name_and_local_code('LANGUAGE_CL2', 2)
                   NcsCode.for_list_name_and_local_code('LANGUAGE_CL5', 1)
        @farsi   = NcsCode.for_list_name_and_local_code('LANGUAGE_CL2', 17)
                   NcsCode.for_list_name_and_local_code('LANGUAGE_CL5', 16)

      end

      describe "for a telephone contact" do

        before(:each) do
          @contact = Factory(:contact,
            :contact_type => @telephone, :contact_language => nil, :contact_interpret => nil,
            :contact_location_code => nil, :contact_private => nil, :who_contacted => nil)
        end

        it "sets the who_contacted to the NCS Participant if there was an instrument taken" do
          response_set, instrument = prepare_instrument(@person, @participant, @survey)

          link = Factory(:contact_link,
            :contact => @contact, :instrument => instrument, :person => @person)

          @contact.populate_post_survey_attributes(instrument)
          @contact.save!
          @contact.who_contacted.should == @ncs_participant
        end

        it "does not set the who_contacted if there was no instrument" do
          @contact.populate_post_survey_attributes(nil)
          @contact.save!
          @contact.who_contacted.local_code.should == -4
        end

        it "sets the contact_location to NCS Site office" do
          @contact.populate_post_survey_attributes(nil)
          @contact.save!
          @contact.contact_location.to_s == "NCS Site office"
        end

        it "sets the contact_private code to No and private_detail is nil" do
          @contact.populate_post_survey_attributes(nil)
          @contact.save!
          @contact.contact_private.to_s.should == "No"
          @contact.contact_private_detail.should be_nil
        end

        it "sets the contact_distance to 0.0" do
          @contact.populate_post_survey_attributes(nil)
          @contact.save!
          @contact.contact_distance.should == 0.0
        end

      end

      describe "for a mail contact" do

        before(:each) do
          @contact = Factory(:contact,
            :contact_type => @mail, :contact_language => nil, :contact_interpret => nil,
            :contact_location => nil, :contact_private => nil, :who_contacted => nil)
        end

        it "sets the contact_location to NCS Site office" do
          @contact.populate_post_survey_attributes(nil)
          @contact.save!
          @contact.contact_location.to_s == "NCS Site office"
        end

        it "sets the contact_private code to No and private_detail is nil" do
          @contact.populate_post_survey_attributes(nil)
          @contact.save!
          @contact.contact_private.to_s.should == "No"
          @contact.contact_private_detail.should be_nil
        end

        it "sets the contact_distance to 0.0" do
          @contact.populate_post_survey_attributes(nil)
          @contact.save!
          @contact.contact_distance.should == 0.0
        end

      end

      describe "for an in person contact" do

        before(:each) do
          @contact = Factory(:contact,
            :contact_type => @in_person, :contact_language => nil, :contact_interpret => nil,
            :contact_location => nil, :contact_private => nil, :who_contacted => nil)
        end

        it "sets the who_contacted to the NCS Participant if there was an instrument taken" do
          response_set, instrument = prepare_instrument(@person, @participant, @survey)

          link = Factory(:contact_link,
            :contact => @contact, :instrument => instrument, :person => @person)

          @contact.populate_post_survey_attributes(instrument)
          @contact.save!
          @contact.who_contacted.should == @ncs_participant
        end

        it "does not set the who_contacted if there was no instrument" do
          @contact.populate_post_survey_attributes(nil)
          @contact.save!
          @contact.who_contacted.local_code.should == -4
        end

        it "sets the contact_location to missing in error" do
          @contact.populate_post_survey_attributes(nil)
          @contact.save!
          @contact.contact_location.local_code.should == -4
        end

        it "sets the contact_private code to Yes" do
          @contact.populate_post_survey_attributes(nil)
          @contact.save!
          @contact.contact_private.local_code.should == -4
        end

        it "sets the contact_private_detail to the text of the contact type" do
          @contact.populate_post_survey_attributes(nil)
          @contact.save!
          @contact.contact_private_detail.should be_nil
        end

        it "sets the contact_distance to 0.0" do
          @contact.populate_post_survey_attributes(nil)
          @contact.save!
          @contact.contact_distance.should be_nil
        end

      end

      describe "setting the disposition based on instrument responses" do

        it "sets the disposition to complete in English"

        it "sets the disposition to complete in Spanish"

        it "sets the disposition to complete in Other Language"

      end

    end

  end

  context "last contact for a participant" do

    it "returns the last contact for a participant" do
    end

  end

  describe "#start" do
    let!(:person) { Factory(:person) }

    before(:each) do
      [
        [1, 'aak', 3, 'red'],
        [3, 'ook', 2, 'green']
      ].each do |lang_code, lang_other, interp_code, interp_other|
        contact = Factory(:contact,
                          :contact_language_code => lang_code,
                          :contact_language_other => lang_other,
                          :contact_interpret_code => interp_code,
                          :contact_interpret_other => interp_other)

        Factory(:contact_link, :contact => contact, :person => person)
      end
    end

    it "defaults the language to the last contact with a language" do
      Contact.start(person).contact_language_code.should == 3
      Contact.start(person).contact_language_other.should == 'ook'
    end

    it "it defaults interpreter to the last contact with an interpreter" do
      Contact.start(person).contact_interpret_code.should == 2
      Contact.start(person).contact_interpret_other.should == 'green'
    end
  end

  describe "#multiple_unique_events_for_contact?" do

    let(:event1) { Factory(:event, :event_type_code => Event.informed_consent_code) }
    let(:event2) { Factory(:event, :event_type_code => Event.pbs_eligibility_screener_code) }
    let(:contact1) { Factory(:contact) }
    let(:contact2) { Factory(:contact) }

    it "returns true if a contact contains multiple events" do
      Factory(:contact_link, :event => event1, :contact => contact1)
      Factory(:contact_link, :event => event2, :contact => contact1)
      contact1.should be_multiple_unique_events_for_contact
    end

    it "returns true if a contact shares an event with other contacts, and contains no additional events" do
      Factory(:contact_link, :event => event1, :contact => contact1)
      Factory(:contact_link, :event => event1, :contact => contact2)
      contact1.should_not be_multiple_unique_events_for_contact
    end

    it "returns true if a contact shares an event with other contacts, and contains additional events" do
      Factory(:contact_link, :event => event1, :contact => contact1)
      Factory(:contact_link, :event => event2, :contact => contact1)
      Factory(:contact_link, :event => event1, :contact => contact2)
      contact1.should be_multiple_unique_events_for_contact
    end

    it "returns false if a contact shares an event with other contacts, and the other contact contain additional events" do
      Factory(:contact_link, :event => event1, :contact => contact1)
      Factory(:contact_link, :event => event2, :contact => contact1)
      Factory(:contact_link, :event => event1, :contact => contact2)
      contact2.should_not be_multiple_unique_events_for_contact
    end

    it "returns false if contact contains no events" do
      contact1.should_not be_multiple_unique_events_for_contact
    end

  end

  describe "#event_disposition_category_for_contact" do

    let(:event1) { Factory(:event, :event_type_code => Event.informed_consent_code) }
    let(:event2) { Factory(:event, :event_type_code => Event.pbs_eligibility_screener_code) }
    let(:contact1) { Factory(:contact) }
    let(:contact2) { Factory(:contact) }

    it "returns General Study category if a contact contains multiple events" do
      Factory(:contact_link, :event => event1, :contact => contact1)
      Factory(:contact_link, :event => event2, :contact => contact1)
                                                     # General Study Category
      contact1.event_disposition_category_for_contact.local_code.should == 3
    end

    it "returns the event's category if a contact contains a single event" do
      Factory(:contact_link, :event => event2, :contact => contact1)
                                                      # PBS Screener Category
      contact1.event_disposition_category_for_contact.local_code.should == 8
    end

    it "returns nil if a contact contains a single event with undefined category" do
      Factory(:contact_link, :event => event1, :contact => contact1)
      contact1.event_disposition_category_for_contact.should be_nil
    end
  end

end
