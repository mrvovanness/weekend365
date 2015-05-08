Feature: Side navigation

  Scenario: Displaying navigation links
    Given I am on the dashboard page
    Then I see "Dashboard" link
    And I see "Employees" link

  Scenario: Moving to dashboard page
    Given I am on the employees page
    When I click "Dashboard" link
    Then I see the dashboard page

  Scenario: Moving to employees page
    Given I am on the dashboard page
    When I click "Employees" link
    Then I see the employees page
