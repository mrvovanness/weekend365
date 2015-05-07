Feature: List of companies page

  Scenario: Move to the company create page
    Given I am on the list of companies page
    When I click "Add a new Company" link
    Then I see the company create page
