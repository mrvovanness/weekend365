Feature: List of companies page

  Scenario: Displaying some companies
    Given the following companies exist:
      | Name |
      | Foo  |
      | Bar  |
      | Baz  |
    And I am on the list of companies page
    Then I see 3 record of companies
    And I see "Foo"
    And I see "Bar"
    And I see "Baz"

  Scenario: Move to the company create page
    Given I am on the list of companies page
    When I click "Add a new Company" link
    Then I see the company create page
