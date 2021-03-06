# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20120629204215
#
# Table name: dwelling_units
#
#  being_processed    :boolean          default(FALSE)
#  created_at         :datetime
#  du_access_code     :integer          not null
#  du_id              :string(36)       not null
#  du_ineligible_code :integer          not null
#  du_type_code       :integer          not null
#  du_type_other      :string(255)
#  duid_comment       :text
#  duplicate_du_code  :integer          not null
#  id                 :integer          not null, primary key
#  listing_unit_id    :integer
#  missed_du_code     :integer          not null
#  psu_code           :integer          not null
#  ssu_id             :string(255)
#  transaction_type   :string(36)
#  tsu_id             :string(255)
#  updated_at         :datetime
#



require 'spec_helper'

describe DwellingUnit do

  it "should create a new instance given valid attributes" do
    du = Factory(:dwelling_unit)
    du.should_not be_nil
  end


  it { should have_many(:dwelling_household_links) }
  it { should have_many(:household_units).through(:dwelling_household_links) }

  context "determining next dwelling unit to process" do

    it "should find all dwelling units not linked to a household" do

      10.times do |x|
        du = Factory(:dwelling_unit)
        Factory(:dwelling_household_link, :dwelling_unit => du) if ((x % 2) == 0)
      end

      DwellingUnit.without_household.size.should == 5
    end

    it "does not choose a dwelling unit that is currently being processed (worked on by another person)" do
      2.times do |x|
        du = Factory(:dwelling_unit)
        Factory(:dwelling_household_link, :dwelling_unit => du) if (x == 1)
      end

      DwellingUnit.next_to_process.size.should == 1

      DwellingUnit.next_to_process.first.update_attribute(:being_processed, true)
      DwellingUnit.next_to_process.should be_empty
    end

  end

  context "ssu and tsu" do

    require 'pathname'
    before(:each) do
      pathname = Pathname.new("#{Rails.root}/spec/spec_ssus.csv")
      DwellingUnit.stub!(:sampling_units_file).and_return(pathname)
    end

    describe "#ssus" do

      it "returns the list of ssu_ids and ssu_names from the configuration sampling_units_file" do
        ssus = DwellingUnit.ssus
        ssus.size.should == 2
        ssus.first.should == ["Area 51", '51']
      end

    end

    describe "#tsus" do

      it "returns the list of tsu_ids and tsu_names from the configuration sampling_units_file" do
        tsus = DwellingUnit.tsus
        tsus.size.should == 1
        tsus.first.should == ["Area 51", '51']
      end

    end

  end

  context "as mdes record" do

    it "sets the public_id to a uuid" do
      du = Factory(:dwelling_unit)
      du.public_id.should_not be_nil
      du.du_id.should == du.public_id
      du.du_id.length.should == 36
    end

    it "uses the ncs_code 'Missing in Error' for all required ncs codes" do

      du = DwellingUnit.new
      du.save!

      DwellingUnit.first.duplicate_du.local_code.should == -4
      DwellingUnit.first.du_ineligible.local_code.should == -4
    end
  end

end

