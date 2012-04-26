Feature: Accessing the specimen page
  @javascript
  Scenario: Accessing a specimen page of the application
    Given valid ncs codes
    And valid specimen receipts
    And valid specimen shippings    
    And an authenticated user
    When I go to the specimens page
    Then I should see "Manifest for specimens"
    And I should see not shipped specimens
    
  @javascript
  Scenario: Selecting specimens to ship
    Given valid ncs codes
    And valid specimen receipts
    And valid specimen shippings    
    And an authenticated user
    When I go to the specimens page
    And I check "FIXTURES001"
    And I press "Ship"
    Then I should be on the verify specimens page
    And I should see selected specimens

  @javascript
  Scenario: Generating specimen manifest with proper fields
    Given valid ncs codes
    And valid specimen receipts
    And valid specimen shippings    
    And an authenticated user
    When I go to the specimens page
    And I check "FIXTURES001"
    And I press "Ship"
    And I enter manifest parameters
    And I enter specimen drop_down parameters
    And I press "Generate Manifest"
    Then I should be on the generate specimens page
    And I should see entered manifest parameters
    And I should see entered specimen drop_down parameters
    And I should see selected specimens
    
  @javascript
  Scenario: Generating specimen manifest without tracking number
    Given valid ncs codes
    And valid specimen receipts
    And valid specimen shippings    
    And an authenticated user
    When I go to the specimens page
    And I check "FIXTURES001"
    And I press "Ship"

    And I enter manifest parameters with error
    And I enter specimen drop_down parameters
    And I press "Generate Manifest"
    # And show me the page
    Then I should be on the generate specimens page
    And I should see "Shipment tracking number can't be blank"
  
  @javascript    
  Scenario: Generating specimen manifest without selecting specimen
    Given valid ncs codes
    And valid specimen receipts
    And valid specimen shippings    
    And an authenticated user
    When I go to the specimens page
    And I should see not shipped specimens
    And I press "Ship"
    Then I should be on the verify specimens page
    And I should see not shipped specimens
    And I should see "Please select specimen to ship"
