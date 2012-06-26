@merge
Feature: Listing sync attempts
  In order to ensure field clients' data is synced with Core
  Site administrators
  Need a way to list and show sync attempts.

  Background:
    Given an authenticated user

  Scenario: Conflicting sync attempts appear at the top of the list
    Given the sync attempts
      | id    | status   |
      | sync1 | merged   |
      | sync2 | conflict |

    When I go to the field client activity page

    Then I see the sync attempts
      | id    | status   |
      | sync2 | Conflict |
      | sync1 | Merged   |
