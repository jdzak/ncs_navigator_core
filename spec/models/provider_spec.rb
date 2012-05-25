# == Schema Information
# Schema version: 20120515181518
#
# Table name: providers
#
#  id                         :integer         not null, primary key
#  psu_code                   :integer         not null
#  provider_id                :string(36)      not null
#  provider_type_code         :integer         not null
#  provider_type_other        :string(255)
#  provider_ncs_role_code     :integer         not null
#  provider_ncs_role_other    :string(255)
#  practice_info_code         :integer         not null
#  practice_patient_load_code :integer         not null
#  practice_size_code         :integer         not null
#  public_practice_code       :integer         not null
#  provider_info_source_code  :integer         not null
#  provider_info_source_other :string(255)
#  provider_info_date         :date
#  provider_info_update       :date
#  provider_comment           :text
#  transaction_type           :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#

require 'spec_helper'

describe Provider do
  it "should create a new instance given valid attributes" do
    provider = Factory(:provider)
    provider.should_not be_nil
  end

  it { should belong_to(:psu) }
  it { should belong_to(:provider_type) }
  it { should belong_to(:provider_ncs_role) }
  it { should belong_to(:practice_info) }
  it { should belong_to(:practice_patient_load) }
  it { should belong_to(:practice_size) }
  it { should belong_to(:public_practice) }
  it { should belong_to(:provider_info_source) }

  context "as mdes record" do

    it "sets the public_id to a uuid" do
      provider = Factory(:provider)
      provider.public_id.should_not be_nil
      provider.provider_id.should == provider.public_id
      provider.provider_id.length.should == 36
    end

    it "uses the ncs_code 'Missing in Error' for all required ncs codes" do
      provider = Provider.new
      provider.psu_code = 20000030
      provider.save!

      obj = Provider.first
      obj.provider_type.local_code.should == -4
      obj.provider_ncs_role.local_code.should == -4
      obj.practice_info.local_code.should == -4
      obj.practice_patient_load.local_code.should == -4
      obj.practice_size.local_code.should == -4
      obj.public_practice.local_code.should == -4
      obj.provider_info_source.local_code.should == -4
    end
  end

end