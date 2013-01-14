# -*- coding: utf-8 -*-
require 'erb'
require 'facets/random'
require 'ostruct'
require 'stringio'

Before '@fieldwork' do
  # Givens establish context that needs to persist between steps.
  @context = {}
end

# We want direct Rack::Test access, but it's not really an API-only
# integration test.
Before '@merge' do
  def browser
    Capybara.current_session.driver.browser
  end

  class << self
    extend Forwardable

    def_delegators :browser, *Rack::Test::Methods::METHODS
  end

  # Write merge log data to a logger that we control.  (It's nice to see the
  # merge log when things go wrong.)
  @logdev = StringIO.new
  Merge.log_device = @logdev

  # Turn off PSC sync.
  def Merge.sync_with_psc?
    false
  end
end

Given /^the participant$/ do |table|
  person_attrs, p_attrs = table.raw.partition { |k, v| k =~ /^person/ }
  person_attrs.map! { |k, v| [k.sub('person/', ''), v] }

  @person = Person.create!(Hash[*person_attrs.flatten])
  @p = Participant.create!(Hash[*p_attrs.flatten])

  @p.person = @person
  @p.save!

  @context.update('participant_id' => @p.public_id)
end

Given /^the event$/ do |table|
  data = table.rows_hash
  type_name = data.delete('event_type')

  code = NcsCode.for_list_name_and_display_text('EVENT_TYPE_CL1', type_name)
  raise "Unknown event type #{type_name}" unless code

  @event = Event.create!(data.merge(:event_type => code,
                                    :event_start_date => data['event_start_date']))

  @p.events << @event
  @p.save!
end

Given /^the surveys$/ do |table|
  table.hashes.each do |h|
    version = h['instrument_version']

    str = %Q{
      survey '#{h['title']}', :instrument_version => '#{version}' do
        section 'Questions' do
          q_1 'Question 1'
          a_1 :string
          q_2 'Question 2'
          a_1 :string
          q_3 'Question 3'
          a_1 :string
        end
      end
    }

    Surveyor::Parser.new.parse(str)
  end
end

Given /^the instrument$/ do
  @instrument = Instrument.start(@person, @p, @survey, @survey, @event, Instrument.cati)
  @instrument.save!

  link = @instrument.link_to(@person, Contact.create!, @event, 'abc')
  link.save!
end

Given /^the responses$/ do |table|
  responses_attrs = table.raw.inject({}) do |memo, raw| 
    idx, k = raw[0].split('/')
    (memo[idx] ||= {}).merge!(k => raw[1])
    memo
  end.values

  responses_attrs.each do |r| 
    ResponseSet.last.responses.create!(
      :question => Question.where(:reference_identifier => r['qref']).first, 
      :answer => Question.where(:reference_identifier => r['qref']).first.answers.where(:reference_identifier => r['aref']).first,
      :string_value => r['string_value'])
  end
end

# FIXME: This is a pretty terrible hack, but Cases' current UI provides no way
# of differentating between response sets.
Given /^there are no response sets for "([^"]*)"$/ do |survey_title|
  survey = Survey.where(:title => survey_title).first
  response_sets = ResponseSet.where(:survey_id => survey.id)
  response_sets.each(&:destroy)

  ResponseSet.where(:survey_id => survey.id).count.should == 0
end

Given /^I complete the fieldwork set$/ do |table|
  data = table.rows_hash

  fixtures_root = File.expand_path('../../fixtures', __FILE__)
  data_file = File.expand_path(data.delete('with'), fixtures_root)

  steps %Q{
    When I POST /api/v1/fieldwork.json with
      | start_date         | #{data['start_date']} |
      | end_date           | #{data['end_date']}   |
      | header:X-Client-ID | #{data['client_id']}  |
    Then the response status is 201
  }

  @context.update(
    'contact_id' => Contact.last.try(:public_id),
    'instrument_id' => Instrument.last.try(:public_id),
    'person_id' => Person.last.try(:public_id),
    'response_set_id' => ResponseSet.last.try(:api_id),
    'survey_id' => Survey.last.try(:api_id),
    'question_ids' => Question.all.map(&:api_id),
    'answer_ids' => Answer.all.map(&:api_id),
    'response_ids' => Response.all.map(&:api_id)
  )

  fieldwork_data = ERB.new(File.read(data_file)).result(binding)

  uri = last_response.headers['Location']
  put "#{uri}?client_id=foo", fieldwork_data
end

When /^the merge runs$/ do
  NcsNavigator::Core::Field::MergeWorker.drain

  if @logdev.string =~ /(error|fatal) --/i
    puts @logdev.string
    raise 'Merge failed; see above log'
  end
end
