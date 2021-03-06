require "spec_helper"

describe MergeMailer do
  let(:recipients) { ['Foo <foo@example.edu>', 'Bar <bar@example.edu>'] }
  let(:merge) { Merge.new }

  shared_examples_for 'a merge message' do
    it 'sets the sender to mail_from' do
      message.from.should == [NcsNavigatorCore.configuration.mail_from]
    end

    it 'handles multiple recipients' do
      message.to.should == ['foo@example.edu', 'bar@example.edu']
    end
  end

  describe '#conflict' do
    let(:message) { MergeMailer.conflict(recipients, merge) }

    it_should_behave_like 'a merge message'

    describe 'message subject' do
      let(:subject) { message.subject }

      it 'identifies the responsible staff member' do
        merge.staff_id = 'foo'

        subject.should =~ /\(staff ID: foo\)/
      end
    end

    describe 'message body' do
      let(:body) { message.body }

      it 'identifies the responsible device' do
        merge.client_id = 'bar'

        body.should =~ /Device ID: bar/
      end

      it 'identifies the responsible staff member' do
        merge.staff_id = 'foo'

        body.should =~ /Staff ID: foo/
      end

      it 'links to the conflict report' do
        core_host = URI(NcsNavigatorCore.configuration.base_uri).host

        fw = Factory(:fieldwork)
        fw.fieldwork_id = 'foo'
        merge.fieldwork = fw
        merge.stub!(:id => 1)

        body.should =~ %r{https://#{core_host}/fieldwork/foo/merges/1}
      end
    end
  end
end
