require 'ncs_navigator/core'
require 'ncs_navigator/warehouse'

module NcsNavigator::Core::Warehouse
  autoload :Enumerator,        'ncs_navigator/core/warehouse/enumerator'
  autoload :EnumeratorHelpers, 'ncs_navigator/core/warehouse/enumerator_helpers'
end
