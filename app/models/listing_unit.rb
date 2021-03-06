# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20120629204215
#
# Table name: listing_units
#
#  being_processed  :boolean          default(FALSE)
#  created_at       :datetime
#  id               :integer          not null, primary key
#  list_comment     :text
#  list_id          :string(36)       not null
#  list_line        :integer
#  list_source_code :integer          not null
#  psu_code         :integer          not null
#  ssu_id           :string(255)
#  transaction_type :string(36)
#  tsu_id           :string(255)
#  updated_at       :datetime
#



# Dwelling Units may be identified during Listing and recorded on a Listing Grid, or obtained from a USPS delivery sequence file,
# or some other data file of dwelling units that can be aligned with a PSU, an SSU and a TSU.
#
# Each row of the Listing table corresponds to a dwelling unit
#
# Data entered into this table is either purchased or obtained from traditional field listing activities.
# Records will be added to this table but will NOT be edited.
#
class ListingUnit < ActiveRecord::Base
  include NcsNavigator::Core::Mdes::MdesRecord
  acts_as_mdes_record :public_id_field => :list_id

  ncs_coded_attribute :psu,         'PSU_CL1'
  ncs_coded_attribute :list_source, 'LISTING_SOURCE_CL1'

  has_one :dwelling_unit

  scope :without_dwelling, joins("LEFT OUTER JOIN dwelling_units ON listing_units.id = dwelling_units.listing_unit_id").where("dwelling_units.id is NULL")
  scope :next_to_process, without_dwelling.where("listing_units.being_processed IS FALSE").readonly(false)

end

