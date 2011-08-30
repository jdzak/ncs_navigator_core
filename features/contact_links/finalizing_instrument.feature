Feature: Finalizing an instrument 
  A contact link record needs to be created when a survey has been completed
  The Contact Link record associates a unique combination of Staff Member, Person, Event, and/or Instrument that occurs during a Contact.
  In order to ensure a contact link record is created after a survey has been completed
  As a user
  I want to complete the entry of the contact link
  
  Scenario: Finalizing an instrument 
  Given a pregnant participant on the ppg1 page with an instrument
  When I follow "Initiate Contact"
  And I select "In-person" from "Contact Type"
  And I press "Submit"
  Then I should be on the select_instrument_contact_link page
  And I should see "Bessie Smith"
  And I should see "INS_QUE_PregVisit1_INT_EHPBHI_P2_V2.0"
  When I follow "INS_QUE_PregVisit1_INT_EHPBHI_P2_V2.0"
  And I press "PREGNANCY CARE LOG INTRODUCTION"
  Then I should see "PREGNANCY CARE LOG INTRODUCTION"
  When I press "Click here to finish"
  Then I should be on the edit_contact_link page
  And I should see "Bessie Smith has completed Instrument - INS_QUE_PregVisit1_INT_EHPBHI_P2_V2.0"
