# -*- coding: utf-8 -*-
Given /^the sync attempts$/ do |table|
  table.hashes.each do |sync|
    id = sync['id']
    status = sync['status']

    steps %Q{
      When I PUT /api/v1/fieldwork/#{id}?client_id=foo with
      """
      {}
      """
      Then the response status is 202
    }

    # Munge status.
    fw = Fieldwork.find_by_fieldwork_id(id)

    fw.update_attribute(:latest_merge_status, status)
  end
end

Given /^merging "([^"]*)" caused conflicts$/ do |fw_id, table|
  fw = Fieldwork.find_by_fieldwork_id(fw_id)

  report = ConflictReport.new

  table.hashes.each do |h|
    entity, public_id = h['entity'].split(' ')

    report.add(entity, public_id, h['attribute'], h['original'], h['current'], h['proposed'])
  end

  fw.merges.create!(:conflict_report => report, :staff_id => 'foo', :client_id => 'bar')
end

# NB: These Then-steps rely on Capybara's #all returning elements in a
# predictable order across invocations.  So far, this seems to be true.

Then /^I see the sync attempts$/ do |table|
  ids = all('.sync_attempt .fieldwork_id').map(&:text).map(&:strip)
  originators = all('.sync_attempt .originator').map(&:text).map(&:strip)
  statuses = all('.sync_attempt .status').map(&:text).map(&:strip)

  actual = [['id', 'generated by', 'status']] + ids.zip(originators, statuses)

  table.diff!(actual)
end

Then /^I see the conflict report$/ do |table|
  keys = %w(entity attribute original current proposed)

  values = keys.map do |klass|
    all(".conflict_report .#{klass}").map(&:text).map(&:strip)
  end

  actual = [keys] + values.first.zip(*values[1..-1])

  table.diff!(actual)
end
