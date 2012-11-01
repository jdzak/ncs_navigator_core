# -*- coding: utf-8 -*-


class PeopleController < ApplicationController

  layout proc { |controller| controller.request.xhr? ? nil : 'application'  }

  permit Role::SYSTEM_ADMINISTRATOR, Role::USER_ADMINISTRATOR, Role::ADMINISTRATIVE_STAFF, Role::STAFF_SUPERVISOR, :only => [:index]

  # GET /people
  # GET /people.json
  def index
    params[:page] ||= 1

    @q = Person.search(params[:q])
    result = @q.result(:distinct => true)
    @people = result.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # GET /people/1
  def show
    @person = Person.find(params[:id])
    @participant = @person.participant
    redirect_to participant_path(@participant) if @participant
  end

  # GET /people/1/provider_staff_member
  def provider_staff_member
    @member = Person.find(params[:id])
    @provider = Provider.find(params[:provider_id])
  end

  # GET /people/1/provider_staff_member_radio_button
  def provider_staff_member_radio_button
    @member = Person.find(params[:id])
    @provider = Provider.find(params[:provider_id])
  end

  # GET /people/new
  # GET /people/new.json
  def new
    unless params[:participant_id].blank?
      @participant = Participant.find(params[:participant_id])
    end

    @person = Person.new
    @provider = Provider.find(params[:provider_id]) unless params[:provider_id].blank?
    if @provider
      @person.person_provider_links.build(:psu_code => @psu_code,
                                          :provider => @provider,
                                          :person   => @person,
                                          :sampled_person_code => 1)
    end

    respond_to do |format|
      format.html # new.html.haml
      format.json  { render :json => @person }
    end
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(params[:person])
    @provider = Provider.find(params[:provider_id]) unless params[:provider_id].blank?

    respond_to do |format|
      if @person.save

        ## Create relationship to participant if participant_id is sent
        if !params[:participant_id].blank? && !params[:relationship_code].blank?
          @participant = Participant.find(params[:participant_id])
          ParticipantPersonLink.create(:participant => @participant, :person => @person,
                                       :relationship_code => params[:relationship_code])
        end

        path = people_path
        msg  = 'Person was successfully created.'
        if @provider
          path = provider_path(@provider)
          msg  = "Person was successfully created for #{@provider}."
        end
        format.html { redirect_to(path, :notice => msg) }
        format.json { render :json => @person }
      else
        format.html { render :action => "new" }
        format.json { render :json => @person.errors }
      end
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
    @provider = Provider.find(params[:provider_id]) unless params[:provider_id].blank?
  end

  # PUT /people/1
  # PUT /people/1.json
  def update
    @person = Person.find(params[:id])
    @provider = Provider.find(params[:provider_id]) unless params[:provider_id].blank?

    respond_to do |format|
      if @person.update_attributes(params[:person])

        path = people_path
        msg  = 'Person was successfully updated.'
        if @provider
          path = provider_path(@provider)
          msg  = "Person was successfully updated for #{@provider}."
        end

        format.html { redirect_to(path, :notice => msg) }
        format.json { render :json => @person }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /people/1/start_instrument
  def start_instrument
    # get information from params
    person = Person.find(params[:id])
    participant = Participant.find(params[:participant_id])
    instrument_survey = Survey.most_recent_for_access_code(params[:references_survey_access_code])
    current_survey = Survey.most_recent_for_access_code(params[:survey_access_code])

    # determine event
    cl = person.contact_links.includes(:event, :contact).find(params[:contact_link_id])
    event = cl.event

    # start instrument
    instrument = Instrument.start(person, participant, instrument_survey, current_survey, event)

    # prepopulate response_set
    base_params = { :person => person, :instrument => instrument, :survey => current_survey, :contact_link => cl }
    NcsNavigator::Core::ResponseSetPopulator::Base.new(base_params).process

    # persist instrument and newly prepopulated response_set
    instrument.save!

    # add instrument to contact link
    link = instrument.link_to(person, cl.contact, event, current_staff_id)
    link.save!

    # redirect
    rs_access_code = instrument.response_sets.where(:survey_id => current_survey.id).last.try(:access_code)
    redirect_to(edit_my_survey_path(:survey_code => params[:survey_access_code], :response_set_code => rs_access_code))
  end

  def responses_for
    @person = Person.find(params[:id])
    if request.put?
      @responses = []
      if params[:data_export_identifier]
        @responses = @person.responses_for(params[:data_export_identifier])
      end
    end
  end

  ##
  # Show changes
  def versions
    @person = Person.find(params[:id])
    if params[:export]
      send_data(@person.export_versions, :filename => "#{@person.public_id}.csv")
    end
  end

end
