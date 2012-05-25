# == Schema Information
# Schema version: 20120515181518
#
# Table name: sample_shippings
#
#  id                                :integer         not null, primary key
#  psu_code                          :integer         not null
#  sample_id                         :string(36)      not null
#  sample_receipt_shipping_center_id :integer
#  staff_id                          :string(36)      not null
#  shipper_id                        :string(36)      not null
#  shipper_destination_code          :integer         not null
#  shipment_date                     :string(10)      not null
#  shipment_coolant_code             :integer         not null
#  shipment_tracking_number          :string(36)      not null
#  shipment_issues_other             :string(255)
#  staff_id_track                    :string(36)
#  sample_shipped_by_code            :integer         not null
#  transaction_type                  :string(36)
#  created_at                        :datetime
#  updated_at                        :datetime
#  volume_amount                     :decimal(6, 2)
#  volume_unit                       :string(36)
#

class SampleShipping < ActiveRecord::Base
  include MdesRecord
  acts_as_mdes_record :public_id_field => :sample_id

  belongs_to :sample_receipt_shipping_center
  ncs_coded_attribute :psu,                         'PSU_CL1'
  ncs_coded_attribute :shipper_destination,         'SHIPPER_DESTINATION_CL1'
  ncs_coded_attribute :shipment_coolant,            'SHIPMENT_TEMPERATURE_CL2'
  ncs_coded_attribute :sample_shipped_by,           'SAMPLES_SHIPPED_BY_CL1'

  validates_presence_of :staff_id 
  validates_presence_of :shipper_id
  validates_presence_of :shipper_destination
  validates_presence_of :shipment_date 
  validates_presence_of :shipment_coolant
  validates_presence_of :shipment_tracking_number
  validates_presence_of :sample_shipped_by
end