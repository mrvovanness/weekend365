Feature: Company create page

  Scenario: Creating new company
    Given I am on the company create page
    When I fill in "company[name]" with "Test Company"
    And I click "Create Company" button
    Then I see the list of companies page
