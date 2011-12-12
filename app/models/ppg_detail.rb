# == Schema Information
# Schema version: 20111212224350
#
# Table name: ppg_details
#
#  id                  :integer         not null, primary key
#  psu_code            :integer         not null
#  ppg_details_id      :string(36)      not null
#  participant_id      :integer
#  ppg_pid_status_code :integer         not null
#  ppg_first_code      :integer         not null
#  orig_due_date       :string(10)
#  due_date_2          :string(10)
#  due_date_3          :string(10)
#  transaction_type    :string(36)
#  created_at          :datetime
#  updated_at          :datetime
#

# Basic non-repeating Pregnancy Probability Group (PPG) status information
# is stored here for each woman who completes a pregnancy screener.
# Eligibility criteria for administration of the pregnancy screener are based on 4 elements:
# * gender (i.e., female);
# * primary residence (i.e., participant lives in a sampled Dwelling Unit);
# * age (i.e., 18-49);
# * currently known as pregnant – regardless of age.
#
# In the event that a mother has several pregnancies, each pregnancy would have its own
# PPG Details record.
# There is a one-to-many relationship between Participant and PPG Details.
class PpgDetail < ActiveRecord::Base
  include MdesRecord
  acts_as_mdes_record :public_id_field => :ppg_details_id

  belongs_to :participant
  ncs_coded_attribute :psu,            'PSU_CL1'
  ncs_coded_attribute :ppg_pid_status, 'PARTICIPANT_STATUS_CL1'
  ncs_coded_attribute :ppg_first,      'PPG_STATUS_CL2'

  def to_s
    "#{ppg_first}"
  end


  ##
  # Return the most recently updated due date
  # @return [String]
  def due_date
    if due_date_3
      due_date_3
    elsif due_date_2
      due_date_2
    elsif orig_due_date
      orig_due_date
    else
      nil
    end
  end

  ##
  # Helper method to set the most recently known due_date
  # @param [Date]
  def update_due_date(due_date)
    if orig_due_date.blank?
      self.update_attribute(:orig_due_date, due_date)
    elsif due_date_2.blank?
      self.update_attribute(:due_date_2, due_date)
    elsif due_date_3.blank?
      self.update_attribute(:due_date_3, due_date)
    else
      nil
    end
  end

end
