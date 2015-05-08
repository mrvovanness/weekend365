Feature: Side navigation

  Scenario: Moving to dashboard page
    Given I am on the employees page
    When I click "Dashboard" link
    Then I see the dashboard page
    And I see active "Dashboard" navigation link

  Scenario: Moving to employees page
    Given I am on the dashboard page
    When I click "Employees" link
    Then I see the employees page
    And I see active "Employees" navigation link
