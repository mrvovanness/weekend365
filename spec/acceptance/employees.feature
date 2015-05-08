Feature: Employees page

  Scenario: Displaying employees page
    Given I am on the employees page
    Then I see the employees page

  Scenario: Displaying action buttons
    Given I am on the employees page
    Then I see 'Add a new Employee' link
    And I see 'Add by File' link
    And I see 'Delete' link
