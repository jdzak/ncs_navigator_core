require 'ncs_navigator/core'

module NcsNavigator::Core
  module Mdes
    autoload :MdesDate,   'ncs_navigator/core/mdes/mdes_date'
    autoload :MdesRecord, 'ncs_navigator/core/mdes/mdes_record'

    autoload :Version, 'ncs_navigator/core/mdes/version'
  end
end
