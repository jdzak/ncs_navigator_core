# == Schema Information
# Schema version: 20110714212419
#
# Table name: person_races
#
#  id               :integer         not null, primary key
#  psu_code         :string(36)      not null
#  person_id        :integer         not null
#  race_code        :integer         not null
#  race_other       :string(255)
#  transaction_type :string(36)
#  person_race_id   :binary          not null
#  created_at       :datetime
#  updated_at       :datetime
#

class PersonRace < ActiveRecord::Base
  include MdesRecord
  acts_as_mdes_record :public_id_field => :person_race_id
  
  belongs_to :person
  belongs_to :psu,  :conditions => "list_name = 'PSU_CL1'",  :class_name => 'NcsCode', :primary_key => :local_code, :foreign_key => :psu_code
  belongs_to :race, :conditions => "list_name = 'RACE_CL1'", :class_name => 'NcsCode', :primary_key => :local_code, :foreign_key => :race_code
  
  validates_presence_of :person
end
