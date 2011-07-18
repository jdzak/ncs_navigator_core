# == Schema Information
# Schema version: 20110715213911
#
# Table name: people
#
#  id                             :integer         not null, primary key
#  psu_code                       :string(36)      not null
#  person_id                      :binary          not null
#  prefix_code                    :integer         not null
#  first_name                     :string(30)
#  last_name                      :string(30)
#  middle_name                    :string(30)
#  maiden_name                    :string(30)
#  suffix_code                    :integer         not null
#  title                          :string(5)
#  sex_code                       :integer         not null
#  age                            :integer
#  age_range_code                 :integer         not null
#  person_dob                     :string(10)
#  date_of_birth                  :date
#  deceased_code                  :integer         not null
#  ethnic_group_code              :integer         not null
#  language_code                  :integer         not null
#  language_other                 :string(255)
#  marital_status_code            :integer         not null
#  marital_status_other           :string(255)
#  preferred_contact_method_code  :integer         not null
#  preferred_contact_method_other :string(255)
#  planned_move_code              :integer         not null
#  move_info_code                 :integer         not null
#  when_move_code                 :integer         not null
#  moving_date                    :date
#  date_move                      :string(255)
#  p_tracing_code                 :integer         not null
#  p_info_source_code             :integer         not null
#  p_info_source_other            :string(255)
#  p_info_date                    :date
#  p_info_update                  :date
#  person_comment                 :text
#  transaction_type               :string(36)
#  created_at                     :datetime
#  updated_at                     :datetime
#

require 'spec_helper'

describe Person do

  it "should create a new instance given valid attributes" do
    pers = Factory(:person)
    pers.should_not be_nil
  end

  it { should belong_to(:psu) }
  it { should belong_to(:prefix) }
  it { should belong_to(:suffix) }
  it { should belong_to(:sex) }
  it { should belong_to(:age_range) }
  it { should belong_to(:deceased) }
  it { should belong_to(:ethnic_group) }
  it { should belong_to(:language) }
  it { should belong_to(:marital_status) }
  it { should belong_to(:preferred_contact_method) }
  it { should belong_to(:planned_move) }
  it { should belong_to(:move_info) }
  it { should belong_to(:when_move) }
  it { should belong_to(:p_tracing) }
  it { should belong_to(:p_info_source) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  
  context "as mdes record" do
    
    it "should set the public_id to a uuid" do
      pers = Factory(:person)
      pers.public_id.should_not be_nil
      pers.person_id.should == pers.public_id
      pers.person_id.length.should == 36
    end
    
    it "should use the ncs_code 'Missing in Error' for all required ncs codes" do
      create_missing_in_error_ncs_codes(Person)
      
      pers = Person.new
      pers.psu = Factory(:ncs_code)
      pers.first_name = "John"
      pers.last_name = "Doe"
      pers.save!
    
      obj = Person.first
      obj.prefix.local_code.should == -4
      obj.suffix.local_code.should == -4
      obj.sex.local_code.should == -4
      obj.age_range.local_code.should == -4
      obj.deceased.local_code.should == -4
      obj.ethnic_group.local_code.should == -4
      obj.language.local_code.should == -4
      obj.marital_status.local_code.should == -4
      obj.preferred_contact_method.local_code.should == -4
      obj.planned_move.local_code.should == -4
      obj.move_info.local_code.should == -4
      obj.when_move.local_code.should == -4
      obj.p_tracing.local_code.should == -4
      obj.p_info_source.local_code.should == -4
    end
  end

end
