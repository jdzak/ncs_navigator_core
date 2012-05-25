require 'spec_helper'

describe SampleReceiptConfirmation do
  it "should create a new instance given valid attributes" do
    sample_receipt_confirmation = Factory(:sample_receipt_confirmation)
    sample_receipt_confirmation.should_not be_nil
  end
  
  it { should belong_to(:sample_receipt_shipping_center) }
  it { should belong_to(:psu) }  
  it { should belong_to(:shipment_receipt_confirmed) }
  it { should belong_to(:shipment_condition) }
  it { should belong_to(:sample_condition) }
  
  context "as mdes record" do
    it "sets the public_id to a uuid" do
      src = Factory(:sample_receipt_confirmation)
      src.public_id.should_not be_nil
      src.sample_id.should == src.public_id
      src.sample_id.to_s.should == "SAMPLE123ID"
    end

    it "uses the ncs_code 'Missing in Error' for all required ncs codes" do
      src = SampleReceiptConfirmation.create(:sample_id => "sampleId", :sample_receipt_shipping_center_id => "srsc_1", 
                                            :shipper_id => "123", :shipment_receipt_datetime => "2012-01-29 22:01:30", :shipment_tracking_number => "67876f5WERSF98",
                                            :shipment_received_by => "Jane Dow", :sample_receipt_temp => "-2.1")
      src.save!

      obj = SampleReceiptConfirmation.find(src.id)
      obj.psu.local_code.should == -4      
      obj.shipment_receipt_confirmed.local_code.should == -4
      obj.shipment_condition.local_code.should == -4
      obj.sample_condition.local_code.should == -4
    end
  end
end