# == Schema Information
# Schema version: 20110624163825
#
# Table name: household_person_links
#
#  id                :integer         not null, primary key
#  psu_code          :string(36)      not null
#  person_id         :integer         not null
#  household_unit_id :integer         not null
#  is_active_code    :integer         not null
#  hh_rank_code      :integer         not null
#  hh_rank_other     :string(255)
#  transaction_type  :string(36)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe HouseholdPersonLink do
  
  it "should create a new instance given valid attributes" do
    hh_pers_link = Factory(:household_person_link)
    hh_pers_link.should_not be_nil
  end
  
  it { should belong_to(:person) }
  it { should belong_to(:psu) }
  it { should belong_to(:household_unit) }
  it { should belong_to(:hh_rank) }
  it { should belong_to(:is_active) }
  
  it { should validate_presence_of(:person) }
  it { should validate_presence_of(:psu) }
  it { should validate_presence_of(:household_unit) }
  it { should validate_presence_of(:hh_rank) }
  it { should validate_presence_of(:is_active) }
  
end
