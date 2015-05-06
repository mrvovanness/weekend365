Feature: List of companies page

  Scenario: Move to new company page
    Given I am on the list of companies page
    When I click "Add a new Company" link
    Then I see the new company page
