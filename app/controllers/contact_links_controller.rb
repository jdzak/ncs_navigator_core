class ContactLinksController < ApplicationController

	# GET /contact_links
  # GET /contact_links.json
  def index
    params[:page] ||= 1

    @q = ContactLink.search(params[:q])
    result = @q.result
    @contact_links = result.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.haml
      format.json { render :json => result.all }
    end
  end

	# GET /contact_links/1/edit
	def edit
		@contact_link = ContactLink.find(params[:id])
		@event        = @contact_link.event
		@instrument   = @contact_link.instrument
		@response_set = @instrument.response_set if @instrument

		@person  = @contact_link.person
		@contact = @contact_link.contact
		@survey  = @response_set.survey if @response_set

	  @contact.set_language_and_interpreter_data(@person)
    @contact.populate_post_survey_attributes(@instrument) if @instrument

    @event.populate_post_survey_attributes(@contact, @response_set) if @response_set
    @event.event_repeat_key = @event.contact_links.count

    @event_activities = psc.activities_for_event(@event)

		set_time_and_dates
		set_disposition_group
	end

	# PUT /contact_links/1
	# PUT /contact_links/1.json
	def update
		@contact_link = ContactLink.find(params[:id])

		respond_to do |format|

			if @contact_link.update_attributes(params[:contact_link]) &&
				 @contact_link.event.update_attributes(params[:event]) &&
				 @contact_link.contact.update_attributes(params[:contact])

         notice = 'Contact was successfully updated.'

        if @contact_link.event.participant.pending_events.blank?
          resp = Event.schedule_and_create_placeholder(psc, @contact_link.event.participant)
          notice += " Could not schedule next event [#{@contact_link.event.participant.next_study_segment}]" unless resp
        end

        format.html {
          if params[:commit] == "Continue"
            redirect_to(edit_person_contact_path(@contact_link.person, @contact_link.contact, :next_event => true), :notice => notice)
          else
            path = @contact_link.person.participant ? participant_path(@contact_link.person.participant) : person_path(@contact_link.person)
            redirect_to(path, :notice => notice)
          end
				}
				format.json { head :ok }
			else
				format.html { render :action => "edit" }
				format.json { render :json => @contact_link.errors, :status => :unprocessable_entity }
			end
		end
	end

	def select_instrument
		@contact_link = ContactLink.find(params[:id])
		@contact			= @contact_link.contact
		@person				= @contact_link.person
		@participant	= @person.participant if @person
		@event				= @contact_link.event
		@event_activities = psc.activities_for_event(@event)
	end

	def edit_instrument
		@contact_link = ContactLink.find(params[:id])

		@person				= @contact_link.person

    @instrument   = find_or_create_instrument(@survey)
		@response_set = @instrument.response_set
		@survey				= @response_set.survey

  	set_instrument_time_and_date(@contact_link.contact)

    @instrument.instrument_repeat_key = @person.instrument_repeat_key(@instrument.survey)
    @instrument.set_instrument_breakoff(@response_set)

    @contact_link.contact.set_language_and_interpreter_data(@person)
    @contact_link.contact.populate_post_survey_attributes(@instrument)
	end

	def finalize_instrument
		@contact_link = ContactLink.find(params[:id])

		respond_to do |format|
			if @contact_link.instrument.update_attributes(params[:instrument])

			  mark_activity_occurred if @contact_link.instrument.complete?

				format.html { redirect_to(edit_contact_link_path(@contact_link), :notice => 'Instrument was successfully updated.') }
				format.json { head :ok }
			else
				format.html { render :action => "edit" }
				format.json { render :json => @contact_link.errors, :status => :unprocessable_entity }
			end
		end

	end

	private

	  def set_time_and_dates
	    contact = @contact_link.contact
	   	contact.contact_end_time = Time.now.strftime("%H:%M")
	   	set_event_time_and_date(contact)
	   	set_instrument_time_and_date(contact)
	  end

	  def set_event_time_and_date(contact)
	   	event = @contact_link.event
	   	if event
	   	  start_date = contact.contact_date_date.nil? ? Date.today : contact.contact_date_date
  	   	event.event_start_date = start_date if event.event_start_date.blank?
  	   	event.event_start_time = contact.contact_start_time
  	   	# TODO: determine if this should be prepopulated
  	   	#       might depend on the response set
        # event.event_end_date = Date.today
        # event.event_end_time = contact.contact_end_time
	   	end
	  end

	  def set_instrument_time_and_date(contact)
	   	instrument = @contact_link.instrument
	   	if instrument
  	   	instrument.instrument_start_date = instrument.created_at.to_date
  	   	instrument.instrument_end_date = Date.today
  	   	instrument.instrument_start_time = instrument.created_at.strftime("%H:%M")
  	   	instrument.instrument_end_time = Time.now.strftime("%H:%M")
  		end
	  end


	  def find_or_create_instrument(survey)
      @contact_link.instrument
	  end

	  ##
	  # Determine the disposition group to be used from the contact type or instrument taken
	  def set_disposition_group
	    @disposition_group = nil
	    if @event
	      set_disposition_group_for_event
      else
        set_disposition_group_for_contact_link
      end
	  end

    ##
    # Disposition group based on specific events
	  def set_disposition_group_for_event
	    case @event.event_type.to_s
	    when "Pregnancy Screener"
        @disposition_group = DispositionMapper::PREGNANCY_SCREENER_EVENT
      when "Informed Consent"
        @disposition_group = DispositionMapper::GENERAL_STUDY_VISIT_EVENT
      when "Low to High Conversion"
        contact = @contact_link.contact
        if contact && contact.contact_type
  	      @disposition_group = @contact_link.contact.contact_type.to_s
  	    else
  	      @disposition_group = DispositionMapper::GENERAL_STUDY_VISIT_EVENT
        end
      else
        set_disposition_group_for_contact_link
      end
	  end

    ##
    # Default logic for setting of disposition group
	  def set_disposition_group_for_contact_link
	    instrument = @contact_link.instrument
	    contact = @contact_link.contact
	    if contact && contact.contact_type
	      @disposition_group = @contact_link.contact.contact_type.to_s
      end
      if instrument && instrument.survey
        @disposition_group = instrument.survey.title
      end
	  end

    def mark_activity_occurred
      activities = psc.activities_for_event(@contact_link.event)

	    activity = nil
	    activities.each do |a|
	      activity = a if @contact_link.instrument.survey.access_code == Instrument.surveyor_access_code(a.labels)
      end

	    if activity
	      psc.update_activity_state(activity.activity_id, @contact_link.person.participant, PatientStudyCalendar::ACTIVITY_OCCURRED)
	    end
    end

end