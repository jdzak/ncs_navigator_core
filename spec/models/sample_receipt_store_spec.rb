# == Schema Information
# Schema version: 20120515181518
#
# Table name: sample_receipt_stores
#
#  id                                :integer         not null, primary key
#  psu_code                          :integer         not null
#  sample_id                         :string(36)      not null
#  sample_receipt_shipping_center_id :integer
#  staff_id                          :string(36)      not null
#  sample_condition_code             :integer         not null
#  receipt_comment_other             :string(255)
#  receipt_datetime                  :datetime        not null
#  cooler_temp_condition_code        :integer         not null
#  environmental_equipment_id        :integer
#  placed_in_storage_datetime        :datetime        not null
#  storage_compartment_area_code     :integer         not null
#  storage_comment_other             :string(255)
#  removed_from_storage_datetime     :datetime
#  temp_event_occurred_code          :integer         not null
#  temp_event_action_code            :integer         not null
#  temp_event_action_other           :string(255)
#  transaction_type                  :string(36)
#  created_at                        :datetime
#  updated_at                        :datetime
#

require 'spec_helper'

describe SampleReceiptStore do
  it "should create a new instance given valid attributes" do
    sample_receipt_store = Factory(:sample_receipt_store)
    sample_receipt_store.should_not be_nil
  end
  
  it { should belong_to(:sample_receipt_shipping_center) }
  it { should belong_to(:environmental_equipment) }
  it { should belong_to(:psu) }  
  it { should belong_to(:sample_condition) }
  it { should belong_to(:cooler_temp_condition) }
  it { should belong_to(:storage_compartment_area) }
  it { should belong_to(:temp_event_occurred) }
  it { should belong_to(:temp_event_action) }
  
  context "as mdes record" do
    it "sets the public_id to a uuid" do
      srs = Factory(:sample_receipt_store)
      srs.public_id.should_not be_nil
      srs.sample_id.should == srs.public_id
      srs.sample_id.to_s.should == "1234567"
    end

    it "uses the ncs_code 'Missing in Error' for all required ncs codes" do
      srs = SampleReceiptStore.create(:sample_id => "sampleId", :staff_id => "me", :placed_in_storage_datetime => "2012-01-29 22:01:30", :receipt_datetime => "2012-01-30 22:01:30")
      srs.save!
 
      obj = SampleReceiptStore.find(srs.id)
      obj.sample_condition.local_code.should == -4
      obj.cooler_temp_condition.local_code.should == -4
      obj.storage_compartment_area.local_code.should == -4
      obj.temp_event_action.local_code.should == -4
      obj.temp_event_occurred.local_code.should == -4
    end
  end  
end