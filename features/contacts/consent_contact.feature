Feature: Obtaining participant consent
  Since all participants must consent to be participants before proceeding with the study
  In order to ensure a consent is recorded
  As a user
  I want to initiate a contact for a participant to obtain consent

  Scenario: Obtaining low intensity consent
    And an authenticated user
    And a registered unconsented trying participant
    When I am on the new contact path for the participant
    Then I should see "Bessie Smith"
    And I should see "Consent required"
    When I select "In person" from "Contact Method"
    And I fill in "Contact Date" with "01/01/2001"
    And I select "NCS Participant" from "Person Contacted"
    And I press "Submit"
    Then I should see "Contact was successfully created."
    And I should be on the select_instrument_contact_link page
    And I should see "Bessie Smith"
    # And I should see "INS_QUE_LIPregNotPreg_INT_LI_P2_V2.0"
    And I should see "Low Intensity Data Collection"
    And I should see "Low Intensity Consent"
    When I follow "Low Intensity Consent"
    Then I should be on the new participant consent page
    And I should see "Consent Type"
    And I should not see the "participant_consent_consent_type_code" text field
    When I select "Yes" from "Consent Given"
    And I press "Submit"
    Then I should see "Participant consent was successfully created."
    And I should be on the decision_page_contact_link page

  Scenario: Obtaining high intensity consent
    And an authenticated user
    And a registered unconsented high intensity trying participant
    When I am on the new contact path for the participant
    Then I should see "Bessie Smith"
    And I should see "Consent required"
    When I select "In person" from "Contact Method"
    And I fill in "Contact Date" with "01/01/2001"
    And I select "NCS Participant" from "Person Contacted"
    And I press "Submit"
    Then I should see "Contact was successfully created."
    And I should be on the select_instrument_contact_link page
    And I should see "Bessie Smith"
    And I should see "General consent"
    # And I should see "Consent to collect biospecimens"
    # And I should see "Consent to collect environmental samples"
    # And I should see "Consent to collect genetic material"
    # And I should see "Consent to collect birth samples"
    # And I should see "Consent for the child’s participation"
    When I follow "General consent"
    Then I should be on the new participant consent page
    When I select "Yes" from "Consent Given"
    And I press "Submit"
    Then I should see "Participant consent was successfully created."
    And I should be on the decision_page_contact_link page
