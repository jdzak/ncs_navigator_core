require 'spec_helper'

# This is a spec for the monkey patch in config/patch_psych_82.rb
describe Psych do
  it 'can roundtrip a non-time timestampish string' do
    ts = '9333-93-93T93:93:93'
    Psych.load(Psych.dump(ts)).should == ts
  end
end
