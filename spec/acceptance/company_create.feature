Feature: Company create page

  Scenario: Creating new company
    Given I am on the company create page
    When I fill in "company[name]" with "Test Company"
    And I click "Create Company" button
    Then I see the list of companies page
    And I see "Company was successfully created."

  Scenario: Creating new company with empty name
    Given I am on the company create page
    When I fill in "company[name]" with ""
    And I click "Create Company" button
    Then I see the company create page
    And I see "can't be blank"
