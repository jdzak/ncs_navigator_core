# == Schema Information
# Schema version: 20111205213437
#
# Table name: events
#
#  id                              :integer         not null, primary key
#  psu_code                        :integer         not null
#  event_id                        :string(36)      not null
#  participant_id                  :integer
#  event_type_code                 :integer         not null
#  event_type_other                :string(255)
#  event_repeat_key                :integer
#  event_disposition               :integer
#  event_disposition_category_code :integer         not null
#  event_start_date                :date
#  event_start_time                :string(255)
#  event_end_date                  :date
#  event_end_time                  :string(255)
#  event_breakoff_code             :integer         not null
#  event_incentive_type_code       :integer         not null
#  event_incentive_cash            :decimal(12, 2)
#  event_incentive_noncash         :string(255)
#  event_comment                   :text
#  transaction_type                :string(255)
#  created_at                      :datetime
#  updated_at                      :datetime
#

# -*- coding: utf-8 -*-
# An Event is a set of one or more scheduled or unscheduled, partially executed or completely executed
# data collection activities with a single subject. The subject may be a Household or a Participant.
# All activities in an Event have the same subject.
class Event < ActiveRecord::Base
  include MdesRecord
  acts_as_mdes_record :public_id_field => :event_id

  belongs_to :participant
  belongs_to :psu,                        :conditions => "list_name = 'PSU_CL1'",                 :foreign_key => :psu_code,                        :class_name => 'NcsCode', :primary_key => :local_code
  belongs_to :event_type,                 :conditions => "list_name = 'EVENT_TYPE_CL1'",          :foreign_key => :event_type_code,                 :class_name => 'NcsCode', :primary_key => :local_code
  belongs_to :event_disposition_category, :conditions => "list_name = 'EVENT_DSPSTN_CAT_CL1'",    :foreign_key => :event_disposition_category_code, :class_name => 'NcsCode', :primary_key => :local_code
  belongs_to :event_breakoff,             :conditions => "list_name = 'CONFIRM_TYPE_CL2'",        :foreign_key => :event_breakoff_code,             :class_name => 'NcsCode', :primary_key => :local_code
  belongs_to :event_incentive_type,       :conditions => "list_name = 'INCENTIVE_TYPE_CL1'",      :foreign_key => :event_incentive_type_code,       :class_name => 'NcsCode', :primary_key => :local_code

  ##
  # A partial ordering of MDES event types. The ordering is such that,
  # if an event of type A and one of type B occur on the same day, A
  # precedes B IFF the event of type A would be executed before the
  # one of type B.
  TYPE_ORDER = [
     1, # Household Enumeration
     2, # Two Tier Enumeration
    22, # Provider-Based Recruitment
     3, # Ongoing Tracking of Dwelling Units
     4, # Pregnancy Screening - Provider Group
     5, # Pregnancy Screening – High Intensity  Group
     6, # Pregnancy Screening – Low Intensity Group
     9, # Pregnancy Screening - Household Enumeration Group
    29, # Pregnancy Screener
    10, # Informed Consent
    33, # Low Intensity Data Collection
    32, # Low to High Conversion
     7, # Pregnancy Probability
     8, # PPG Follow-Up by Mailed SAQ
    11, # Pre-Pregnancy Visit
    12, # Pre-Pregnancy Visit SAQ
    13, # Pregnancy Visit  1
    14, # Pregnancy Visit #1 SAQ
    15, # Pregnancy Visit  2
    16, # Pregnancy Visit #2 SAQ
    17, # Pregnancy Visit - Low Intensity Group
    18, # Birth
    19, # Father
    20, # Father Visit SAQ
    21, # Validation
    23, # 3 Month
    24, # 6 Month
    25, # 6-Month Infant Feeding SAQ
    26, # 9 Month
    27, # 12 Month
    28, # 12 Month Mother Interview SAQ
    30, # 18 Month
    31, # 24 Month
    -5, # Other
    -4  # Missing in Error
  ]

  ##
  # Display text from the NcsCode list EVENT_TYPE_CL1
  # cf. event_type belongs_to association
  # @return [String]
  def to_s
    event_type.to_s
  end

  ##
  # Format the event start date
  # @return [String]
  def event_start
    result = "#{event_start_date} #{event_start_time}"
    result = "N/A" if result.blank?
    result
  end

  ##
  # Format the event end date
  # @return [String]
  def event_end
    result = "#{event_end_date} #{event_end_time}"
    result = "N/A" if result.blank?
    result
  end

  ##
  # An event is 'closed' or 'completed' if the disposition has been set.
  # @return [true, false]
  def closed?
    event_disposition.to_i > 0
  end
  alias completed? closed?
  alias complete? closed?

  ##
  # Using the InstrumentEventMap, find the existing Surveys for this event
  # @return [Array, <Survey>]
  def surveys
    surveys = []
    InstrumentEventMap.instruments_for_segment(self.to_s).each do |ins|
      surveys << Survey.most_recent_for_title(ins)
    end
    surveys
  end

  ##
  # For this event.event_type return the corresponding PSC segment name from the template
  def psc_segment_name
    result = nil
    PSC_SEGMENT_EVENT_CONFIG.each do |e|
      if event_type.to_s == e["event_type"]
        result = e["psc_segment"]
        break
      end
    end
    result
  end

  ##
  # Determines if the disposition code is complete based on the disposition category
  # and the disposition code
  # @return [true,false]
  def disposition_complete?

    # TODO: move knowledge of disposition codes out of event
    # TODO: do not hard code code lists and disposition codes here
    if event_disposition_category && event_disposition
      case event_disposition_category.local_code
      when 1 # Household Enumeration
        (540..545) === event_disposition
      when 2 # Pregnancy Screener
        (560..565) === event_disposition
      when 3 # General Study
        (560..562) === event_disposition
      when 4 # Mailed Back SAQ
        (550..556) === event_disposition
      when 5 # Telephone Interview
        (590..595) === event_disposition
      when 6 # Internet Survey
        (540..546) === event_disposition
      else
        false
      end
    end
  end
  
  ##
  # Given an instrument and contact, presumably after the instrument has been administered, set attributes on the
  # event that can be inferred based on the instrument and type of contact
  # @param [Instrument]
  # @param [Contact]
  def populate_post_survey_attributes(contact = nil, response_set = nil)
    set_event_disposition_category(contact)
    set_event_breakoff(response_set)
  end
  
  def set_event_disposition_category(contact)
    case event_type.to_s 
    when /Pregnancy Screen/
      # Pregnancy Screener Disposition Category Local Code = 2
      self.event_disposition_category = NcsCode.for_attribute_name_and_local_code(:event_disposition_category_code, 2)
    when /Household/
      # Household Event Disposition Category Local Code = 1
      self.event_disposition_category = NcsCode.for_attribute_name_and_local_code(:event_disposition_category_code, 1)
    end
    
    if self.event_disposition_category.to_i <= 0
      
      case contact.contact_type.to_i
      when 1 # in person contact
        # General Study Visit Category Local Code = 3
        self.event_disposition_category = NcsCode.for_attribute_name_and_local_code(:event_disposition_category_code, 3)
      when 2 # mail contact
        # Mail Disposition Category Local Code = 4
        self.event_disposition_category = NcsCode.for_attribute_name_and_local_code(:event_disposition_category_code, 4)
      when 3 # telephone contact
        # Telephone Disposition Category Local Code = 5
        self.event_disposition_category = NcsCode.for_attribute_name_and_local_code(:event_disposition_category_code, 5)
      when 5, 6 # text or website
        # Website Disposition Category Local Code = 6
        self.event_disposition_category = NcsCode.for_attribute_name_and_local_code(:event_disposition_category_code, 6)
      end
    end
  end
  private :set_event_disposition_category
  
  def set_event_breakoff(response_set)
    if response_set 
      local_code = response_set.has_responses_in_each_section_with_questions? ? 2 : 1 
      self.event_breakoff = NcsCode.for_attribute_name_and_local_code(:event_breakoff_code, local_code)
    end
  end
  private :set_event_breakoff

end
