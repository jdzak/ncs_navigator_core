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

class SampleReceiptStore < ActiveRecord::Base
  include MdesRecord
  acts_as_mdes_record :public_id_field => :sample_id

  belongs_to :sample_receipt_shipping_center
  belongs_to :environmental_equipment  
  ncs_coded_attribute :psu,                       'PSU_CL1'
  ncs_coded_attribute :sample_condition,          'SPECIMEN_STATUS_CL7'
  ncs_coded_attribute :cooler_temp_condition,     'COOLER_TEMP_CL1'
  ncs_coded_attribute :storage_compartment_area,  'STORAGE_AREA_CL2'
  ncs_coded_attribute :temp_event_occurred,       'CONFIRM_TYPE_CL20'
  ncs_coded_attribute :temp_event_action,         'SPECIMEN_STATUS_CL6'
  
  validates_presence_of :staff_id
  validates_presence_of :receipt_datetime
  validates_presence_of :placed_in_storage_datetime
end