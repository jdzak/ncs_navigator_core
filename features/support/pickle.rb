# this file generated by script/generate pickle [paths] [email]
#
# Make sure that you are loading your factory of choice in your cucumber environment
#
# For machinist add: features/support/machinist.rb
#
#    require 'machinist/active_record' # or your chosen adaptor
#    require File.dirname(__FILE__) + '/../../spec/blueprints' # or wherever your blueprints are
#    Before { Sham.reset } # to reset Sham's seed between scenarios so each run has same random sequences
#
# For FactoryGirl add: features/support/factory_girl.rb
#
#    require 'factory_girl'
#    require File.dirname(__FILE__) + '/../../spec/factories' # or wherever your factories are
#
# You may also need to add gem dependencies on your factory of choice in <tt>config/environments/cucumber.rb</tt>

# ***********************
# Uncomment the following if not using spork & guard
# require 'factory_girl'
# require File.dirname(__FILE__) + '/../../spec/factories'
# require File.dirname(__FILE__) + '/../../spec/factories/surveyor'
# require File.dirname(__FILE__) + '/../../spec/factories/household'
# require File.dirname(__FILE__) + '/../../spec/factories/consent'
# require File.dirname(__FILE__) + '/../../spec/factories/participant'
# require File.dirname(__FILE__) + '/../../spec/factories/ppg'
# ***********************

require 'pickle/world'
# Example of configuring pickle:
#
# Pickle.configure do |config|
#   config.adapters = [:machinist]
#   config.map 'I', 'myself', 'me', 'my', :to => 'user: "me"'
# end

# Setting predicates explicitly to ensure default capture_predicate method used in pickle_steps
# does not throw a 'regular expression too big' exception
# http://groups.google.com/group/pickle-cucumber/browse_thread/thread/c6be23c6247fa0dd?pli=1

Pickle.configure do |config|
  config.adapters = [:factory_girl]
  config.predicates = %w(exist)
end

require 'pickle/path/world'
