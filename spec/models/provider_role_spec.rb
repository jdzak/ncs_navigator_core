require 'spec_helper'

describe ProviderRole do
  it "should create a new instance given valid attributes" do
    provider_role = Factory(:provider_role)
    provider_role.should_not be_nil
  end

  it { should belong_to(:psu) }
  it { should belong_to(:provider) }
  it { should belong_to(:provider_ncs_role) }

  context "as mdes record" do

    it "sets the public_id to a uuid" do
      provider_role = Factory(:provider_role)
      provider_role.public_id.should_not be_nil
      provider_role.provider_role_id.should == provider_role.public_id
      provider_role.provider_role_id.length.should == 36
    end

    it "uses the ncs_code 'Missing in Error' for all required ncs codes" do
      provider_role = ProviderRole.new
      provider_role.psu_code = 20000030
      provider_role.save!

      obj = ProviderRole.first
      obj.provider_ncs_role.local_code.should == -4
    end
  end
end
