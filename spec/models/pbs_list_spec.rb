require 'spec_helper'

describe PbsList do
  it "should create a new instance given valid attributes" do
    pbs_list = Factory(:pbs_list)
    pbs_list.should_not be_nil
  end

  it { should belong_to(:psu) }
  it { should belong_to(:provider) }
  it { should belong_to(:substitute_provider) }
  it { should belong_to(:in_out_frame) }
  it { should belong_to(:in_sample) }
  it { should belong_to(:in_out_psu) }
  it { should belong_to(:cert_flag) }
  it { should belong_to(:frame_completion_req) }
  it { should belong_to(:pr_recruitment_status) }

  it { should validate_presence_of(:provider) }

  context "as mdes record" do

    it "sets the public_id to a uuid" do
      pbs_list = Factory(:pbs_list)
      pbs_list.public_id.should_not be_nil
      pbs_list.pbs_list_id.should == pbs_list.public_id
      pbs_list.pbs_list_id.length.should == 36
    end

    it "uses the ncs_code 'Missing in Error' for all required ncs codes" do
      pbs_list = PbsList.new
      pbs_list.psu_code = 20000030
      pbs_list.provider = Factory(:provider)
      pbs_list.save!

      obj = PbsList.first
      obj.frame_completion_req.local_code.should == -4

      obj.in_out_frame.local_code.should == -4
      obj.in_sample.local_code.should == -4
      obj.in_out_psu.local_code.should == -4
      obj.cert_flag.local_code.should == -4
      obj.pr_recruitment_status.local_code.should == -4
    end
  end

  context "provider recruitment" do

    let(:pbs_list) { Factory(:pbs_list, :pr_recruitment_start_date => nil, :pr_cooperation_date => nil, :pr_recruitment_end_date => nil) }

    it "knows if provider recruitment has started" do
      pbs_list.should_not be_recruitment_started
      pbs_list.pr_recruitment_start_date = Date.today
      pbs_list.pr_recruitment_status_code = 3
      pbs_list.should be_recruitment_started
    end

    it "knows when provider recruitment has ended" do
      pbs_list.should_not be_recruitment_ended
      pbs_list.pr_recruitment_end_date = Date.today
      pbs_list.pr_recruitment_status_code = 1
      pbs_list.should be_recruitment_ended
    end

  end

  describe ".has_substitute_provider?" do

    it "returns true if the pbs_list record has an associated substitute_provider" do
      provider = Factory(:provider, :name_practice => "provider")
      sub = Factory(:provider, :name_practice => "substitute_provider")
      Factory(:pbs_list, :provider => provider, :substitute_provider => sub).has_substitute_provider?.should be_true
    end

    it "returns false if the pbs_list record does not have an associated substitute_provider" do
      provider = Factory(:provider, :name_practice => "provider")
      Factory(:pbs_list, :provider => provider, :substitute_provider => nil).has_substitute_provider?.should be_false
    end

  end

end
