# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20120629204215
#
# Table name: fieldworks
#
#  client_id           :string(255)
#  created_at          :datetime
#  end_date            :date
#  fieldwork_id        :string(36)
#  generation_log      :text
#  id                  :integer          not null, primary key
#  latest_merge_id     :integer
#  latest_merge_status :string(255)
#  original_data       :binary
#  staff_id            :string(255)
#  start_date          :date
#  updated_at          :datetime
#



require 'patient_study_calendar'
require 'uuidtools'

class Fieldwork < ActiveRecord::Base
  has_many :merges, :inverse_of => :fieldwork

  before_create :set_default_id
  before_save :serialize_report

  attr_accessible :client_id
  attr_accessible :end_date
  attr_accessible :start_date

  validates_presence_of :client_id
  validates_presence_of :end_date
  validates_presence_of :start_date

  ##
  # An ephemeral attribute that, if set, should point to a
  # {ScheduledActivityReport}.
  #
  # When this is set on a Fieldwork instance FW and FW is saved, the following
  # actions occur in a before_save hook on FW:
  #
  # 1) All new entities associated with the report are saved.
  # 2) FW's original_data attribute is set to a Fieldwork-specific JSON
  #    representation of the report.
  #
  # For more information on said representation, see the fieldwork schema in
  # the ncs_navigator_schema repository.
  #
  # @see https://github.com/NUBIC/ncs_navigator_schema
  attr_accessor :report

  ##
  # Retrieves a fieldwork set by ID.  If no fieldwork set by that ID can be
  # found, initializes an empty set, saves it, and returns that set.
  #
  # This method therefore has the ability to violate the presence validations
  # listed above.  This privilege is intentional: we want to be able to save
  # datasets from field clients even if they give us a fieldwork ID that we
  # know nothing about, but we also want to encode the idea that we _usually_
  # expect a date range and client ID.
  def self.for(id, staff_id)
    find_or_initialize_by_fieldwork_id(id).tap do |r|
      r.staff_id = staff_id

      r.save!(:validate => false)
    end
  end

  ##
  # Shows all conflicting fieldwork records (as determined by latest merge
  # status) first, followed by all other fieldwork records.
  def self.for_report
    order("(CASE latest_merge_status WHEN 'conflict' THEN 1 ELSE 0 END) DESC, updated_at DESC")
  end

  ##
  # Retrieves scheduled activities from PSC for a given closed date interval
  # and builds a fieldwork set from that data.
  #
  # The constructed fieldwork set will be associated with other unpersisted
  # model objects that will be saved once the fieldwork set is saved.
  #
  # The following parameters are required:
  #
  # * `:start_date`: the start date
  # * `:end_date`: the end date
  # * `:client_id`: the ID of the field client
  #
  # This method stores logs about the PSC -> Core entity mapping process in
  # {#generation_log}.
  #
  # @param Hash params fieldwork parameters
  # @param PatientStudyCalendar psc a PSC client instance
  # @param staff_id the name of the user running this process;
  #   should usually be the value of ApplicationController#current_staff_id
  # @return [Fieldwork]
  def self.from_psc(params, psc, staff_id, current_username)
    sd = params[:start_date]
    ed = params[:end_date]
    cid = params[:client_id]

    new(:start_date => sd, :end_date => ed, :client_id => cid).tap do |f|
      sio = StringIO.new
      report = Field::ScheduledActivityReport.from_psc(psc, :start_date => sd, :end_date => ed, :state => Psc::ScheduledActivity::SCHEDULED, :current_user => current_username)
      report.logger = ::Logger.new(sio).tap { |l| l.formatter = ::Logger::Formatter.new }
      report.staff_id = staff_id

      report.process

      f.generation_log = sio.string
      f.report = report
      f.staff_id = staff_id
    end
  end

  def set_default_id
    self.fieldwork_id ||= UUIDTools::UUID.random_create.to_s
  end

  def latest_merge
    merges.order(:created_at).last
  end

  def latest_proposed_data
    latest_merge.try(:proposed_data)
  end

  def as_json(options = nil)
    JSON.parse(latest_proposed_data || original_data)
  end

  def serialize_report
    return true unless report

    report.save_models and self.original_data = report.to_json
  end
end

