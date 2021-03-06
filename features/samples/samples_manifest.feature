Feature: Accessing the samples page
  @javascript @wip
  Scenario: Accessing a sample page of the application
    Given valid sample receipts
    And valid sample shippings
    And an authenticated user
    When I go to the samples page
    Then I should see not shipped samples
  @javascript @wip
  Scenario: Should be action free when no selected samples
    Given valid sample receipts
    And valid sample shippings
    And an authenticated user
    When I go to the samples page
    Then I should see not shipped samples
    And I press "Ship"
    Then I should be on the verify samples page
    And I should see not shipped samples
    And I should see "Please select sample to ship"
  @javascript @wip
  Scenario: Selecting samples to ship
    Given valid sample receipts
    And valid sample shippings
    And an authenticated user
    When I go to the samples page
    And I check "SAMPLE_FIXTURES-UR11"
    And I check "SAMPLE_FIXTURES-RB10"
    And I press "Ship"
    Then I should be on the verify samples page

  @javascript @wip
  Scenario: Generating sample manifest with proper fields
    Given valid sample receipts
    And valid sample shippings
    And an authenticated user
    When I go to the samples page
    And I check "SAMPLE_FIXTURES-UR11"
    And I check "SAMPLE_FIXTURES-RB10"
    And I press "Ship"
    Then I enter manifest parameters
    And I enter sample drop_down parameters
    And I press "Generate Manifest"
    Then I should be on the generate samples page
    And I should see entered manifest parameters
    And I should see entered sample drop_down parameters
    And I should see selected samples

  @javascript @wip
  Scenario: Generating sample manifest without tracking number
    Given valid sample receipts
    And valid sample shippings
    And an authenticated user
    When I go to the samples page
    And I check "SAMPLE_FIXTURES-UR11"
    And I check "SAMPLE_FIXTURES-RB10"
    And I press "Ship"
    When I enter manifest parameters with error
    And I enter sample drop_down parameters
    And I press "Generate Manifest"
    Then I should be on the generate samples page
    And I should see "Shipment tracking number can't be blank"
