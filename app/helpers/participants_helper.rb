# -*- coding: utf-8 -*-


module ParticipantsHelper
  include ActionView::Helpers::UrlHelper

  def switch_arm_message(participant)
    msg = "Invite #{participant.person} to join High Intensity Arm"
    msg = "Move #{participant.person} from High Intensity to Low Intensity" if participant.high_intensity
    msg
  end

  def psc_assignment_path(assignment_id)
    "#{NcsNavigator.configuration.psc_uri}pages/subject?assignment=#{assignment_id}"
  end

  ##
  # @param [Participant]
  # @return [NcsCode]
  def consent_type_for(participant)
    participant.low_intensity? ? ParticipantConsent.low_intensity_consent_type_code : ParticipantConsent.general_consent_type_code
  end

  ##
  # Determine the path for the Participant's ParticipantConsent
  # record. Basically this determines if this is an edit or a new
  # action on the ParticipantConsent and build the url link accordingly.
  #
  # @param participant [Participant]
  # @param contact_link [ContactLink]
  # @param current_activity [Boolean]
  # @return [String] link tag
  def determine_participant_consent_path(participant, contact_link, current_activity = false)
    consent = consent_type_for(participant)
    return nil if should_hide_consent?(consent.display_text)

    consent_type_code = consent.local_code
    consent_type = NcsCode.for_attribute_name_and_local_code(:consent_type_code, consent_type_code)
    if participant.consented?(consent_type)

      participant_consent = participant.consent_for_type(consent_type)

      if participant_consent.consent_event == contact_link.event
        build_edit_participant_consent_path(participant, participant_consent, contact_link, current_activity)
      else
        build_new_participant_consent_path(participant, consent_type_code, contact_link, current_activity)
      end
    else
      build_new_participant_consent_path(participant, consent_type_code, contact_link, current_activity)
    end
  end

  ##
  # Build the url path for the new participant consent action
  # @param participant [Participant]
  # @param consent_type_code [NcsCode]
  # @param contact_link [ContactLink]
  # @param current_activity [Boolean]
  # @return [String] link tag
  def build_new_participant_consent_path(participant, consent_type_code, contact_link, current_activity)
    path = new_participant_participant_consent_path(participant,
             {:contact_link_id => contact_link.id, :consent_type_code => consent_type_code})
    informed_consent_link("New", path, current_activity)
  end
  private :build_new_participant_consent_path

  ##
  # Build the url path for the edit participant consent action
  # @param participant [Participant]
  # @param participant_consent [ParticipantConsent]
  # @param contact_link [ContactLink]
  # @param current_activity [Boolean]
  # @return [String] link tag
  def build_edit_participant_consent_path(participant, participant_consent, contact_link, current_activity)
    path = edit_participant_participant_consent_path(participant, participant_consent,
             {:contact_link_id => contact_link.id})
    informed_consent_link("Edit", path, current_activity)
  end
  private :build_edit_participant_consent_path

  ##
  # If this is the current activity use the star_link css style
  # otherwise use the new_link or edit_link css style as determined
  # by the action parameter
  # @param current_activity [Boolean]
  # @param action [String] 'new' or 'edit'
  # @return [String]
  def css_link_class(current_activity, action)
    current_activity ? "star_link icon_link" : "#{action}_link icon_link"
  end
  private :css_link_class

  ##
  # @see ActionView::Helpers::UrlHelper#link_to
  # @return [String] link tag
  def informed_consent_link(action, path, current_activity)
    link_to "#{action} Informed Consent", path, :class => css_link_class(current_activity, action.downcase)
  end
  private :informed_consent_link

  def should_hide_consent?(consent_type_text)
    consent_type_text.include?("collect") && !NcsNavigatorCore.expanded_phase_two?
  end

  def should_show_informed_consent_scheduling_form?(participant)
    !participant.ineligible? && !(participant.pending_events.first.try(:event_type_code) == Event.informed_consent_code)
  end

  def upcoming_events_for(person_or_participant)
    result = person_or_participant.upcoming_events.to_sentence
    result = remove_two_tier(result) unless recruitment_strategy.two_tier_knowledgable?
    result
  end

  def displayable_next_scheduled_event(event)
    result = event.to_s
    result = remove_two_tier(result) unless recruitment_strategy.two_tier_knowledgable?
    result
  end

  def remove_two_tier(txt)
    txt.to_s.gsub("#{PatientStudyCalendar::HIGH_INTENSITY}: ", '').gsub("#{PatientStudyCalendar::LOW_INTENSITY}: ", '')
  end
  private :remove_two_tier

  ##
  # Remove the 'Part One' or 'Part Two' (etc.) from the
  # given activity name. If the name parameter is nil,
  # this method will return an empty string.
  # @param name [String]
  # @return [String]
  def strip_part_from_activity_name(name)
    name.to_s.sub(/(.*?)\s*Part\b.*\Z/i) { $1 }
  end

  def activity_link_name(activity)
    name = "#{strip_part_from_activity_name(activity.activity_name)}"
    if activity.participant.has_children? || activity.participant.child_participant?
      name << " (#{activity.participant.person.full_name})"
    end
    name
  end

  def saq_confirmation_message(event)
    msg = event.closed? ? "This event is already closed.\n\n" : ""
    msg << "Would you like to record or add more information to the Self-Administered Questionnaire (SAQ)\n"
    msg << "for the #{event.event_type.to_s} Event?"
    msg
  end

  ##
  # Determine if the activities include a child consent
  def activities_include_child_consent?(activities_for_event)
    activities_for_event.find{ |sa| sa.child_consent? }
  end

  ##
  # "Originating Staff"
  # The name of the user that initiated the participant in the system
  # (e.g. the person who administered the eligibility screener).
  # @param[Participant]
  # @return[String]
  def participant_staff(participant)
    if participant && participant.completed_event?(screener_event)
      staff_name(originating_staff_id(participant))
    end
  end

  ##
  # The public identifier of the Staff member who
  # administered the screener instrument to the Participant.
  # @param[Participant]
  # @return[String]
  def originating_staff_id(participant)
    event = screener_event_for_participant(participant)
    instrument = instrument_for_screener_event(event)
    originating_staff(participant, event, instrument).try(:staff_id)
  end
  private :originating_staff_id

  ##
  # The ContactLink for the Participant, Event, and Instrument.
  # Used to get the staff_id for the screener event.
  # @param[Event]
  # @param[Instrument]
  # @return[ContactLink]
  def originating_staff(participant, event, instrument)
    participant.contact_links.where(:event_id => event,
        :instrument_id => instrument).select("staff_id").first
  end
  private :originating_staff

  ##
  # The screener event associated with the participant
  # @param[Participant]
  # @return[Event]
  def screener_event_for_participant(participant)
    event_codes = [
      Event.pbs_eligibility_screener_code,
      Event.pregnancy_screener_code
    ]
    Event.where(:event_type_code => event_codes, :participant_id => participant).select("id")
  end
  private :screener_event_for_participant

  ##
  # The instrument used during the screener event.
  # @param[Event]
  # @return[Instrument]
  def instrument_for_screener_event(event)
    instrument_codes = [
      Instrument.pbs_eligibility_screener_code,
      Instrument.pregnancy_screener_eh_code,
      Instrument.pregnancy_screener_pb_code,
      Instrument.pregnancy_screener_hilo_code,
    ]
    Instrument.where(:instrument_type_code => instrument_codes, :event_id => event).select("id")
  end
  private :instrument_for_screener_event

  ##
  # The screener event NcsCode based on Recruitment Strategy
  # @return[NcsCode]
  def screener_event
    NcsNavigatorCore.recruitment_strategy.pbs? ? NcsCode.pbs_eligibility_screener : NcsCode.pregnancy_screener
  end
  private :screener_event

  def psc_activity_options(activity)
    opts = ""
    Psc::ScheduledActivity::STATES.each do |a|
      opts << "<option value=\"#{a}\""
      opts << " selected=\"selected\"" if activity.current_state == a
      txt = a == Psc::ScheduledActivity::NA ? "N/A" : a.titleize
      opts << ">#{txt}</option>"
    end
    opts.html_safe
  end

end
