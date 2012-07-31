require 'spec_helper'

describe ScheduledActivity do

  def attrs
    {
      :study_segment => "HI-Intensity: Child",
      :activity_id => "activity_id",
      :current_state => "scheduled",
      :ideal_date => "2011-01-01",
      :date => "2011-01-01",
      :activity_name => "Birth Interview",
      :activity_type => "Instrument",
      :person_id => "asdf",
      :labels => "event:birth instrument:ins_que_birth_int_ehpbhi_p2_v2.0_baby_name order:01_02 participant_type:child references:ins_que_birth_int_ehpbhi_p2_v2.0"
    }
  end

  describe ".new" do
    it "accepts a hash as a parameter to the constructor" do
      ScheduledActivity.new(attrs).should_not be_nil
    end
  end

  describe ".consent_activity?" do
    it "is true if the ScheduledActivity.activity_type includes the word Consent" do
      ScheduledActivity.new(:activity_type => "Consent").should be_consent_activity
    end

    it "is false if the ScheduledActivity.activity_type does not include the word Consent" do
      ScheduledActivity.new(:activity_type => "Instrument").should_not be_consent_activity
    end

    it "is false if the ScheduledActivity.activity_type is blank" do
      ScheduledActivity.new(:activity_type => nil).should_not be_consent_activity
    end
  end

  context "understanding the labels" do

    let(:scheduled_activity) { ScheduledActivity.new(attrs) }

    describe ".participant_type" do
      it "extracts participant_type from the label" do
        scheduled_activity.participant_type.should == "child"
      end
    end

    describe ".event" do
      it "extracts event from the label" do
        scheduled_activity.event.should == "birth"
      end
    end

    describe ".order" do
      it "extracts order from the label" do
        scheduled_activity.order.should == "01_02"
      end
    end

    describe ".instrument" do
      it "extracts instrument from the label" do
        scheduled_activity.instrument.should == "ins_que_birth_int_ehpbhi_p2_v2.0_baby_name"
      end
    end

    describe ".references" do
      it "extracts references from the label" do
        scheduled_activity.references.should == "ins_que_birth_int_ehpbhi_p2_v2.0"
      end
    end

  end

  context "sorting" do

    let(:sc1) { ScheduledActivity.new(:labels => "event:a order:01_01") }
    let(:sc2) { ScheduledActivity.new(:labels => "event:a order:01_02") }
    let(:sc3) { ScheduledActivity.new(:labels => "event:a") }

    describe ".<=>" do

      it "sorts by the order attribute" do
        (sc1.<=> sc2).should == -1
      end

      it "sorts" do
        [sc2, sc1].sort.should == [sc1, sc2]
      end

      it "places items without an explicit order at the end" do
        [sc3, sc2, sc1].sort.should == [sc1, sc2, sc3]
      end

    end

    context "with instruments" do

      let(:sc11) { ScheduledActivity.new(:labels => "order:01_01 instrument:A") }
      let(:sc12) { ScheduledActivity.new(:labels => "order:01_01 instrument:A.B") }

      describe ".<=>" do

        it "sorts by the order attribute then the instrument name" do
          (sc11.<=> sc12).should == -1
        end

        it "sorts" do
          [sc12, sc11].sort.should == [sc11, sc12]
        end

      end

    end

    context "with people" do

      let(:p1)   { Factory(:participant, :p_id => "a") }
      let(:p2)   { Factory(:participant, :p_id => "b") }

      let(:sc11) { ScheduledActivity.new(:labels => "order:01_01 instrument:X", :participant => p1) }
      let(:sc12) { ScheduledActivity.new(:labels => "order:01_01 instrument:X", :participant => p2) }

      describe ".<=>" do

        it "sorts by the order attribute, instrument name, then participant_id.p_id" do
          (sc11.<=> sc12).should == -1
        end

        it "sorts" do
          [sc12, sc11].sort.should == [sc11, sc12]
        end

      end

    end

  end

end