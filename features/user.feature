Feature: User
  Background:
    Given User "John Doe" exists
    And "John Doe" owns private project "Enterprise"

  # Signed out

  Scenario: I visit user "John Doe" page while not signed in when he owns a public project
    Given "John Doe" owns internal project "Internal"
    And "John Doe" owns public project "Community"
    When I visit user "John Doe" page
    Then I should see user "John Doe" page
    And I should not see project "Enterprise"
    And I should not see project "Internal"
    And I should see project "Community"

  # Signed in as someone else

  Scenario: I visit user "John Doe" page while signed in as someone else when he owns a public project
    Given "John Doe" owns public project "Community"
    And "John Doe" owns internal project "Internal"
    And I sign in as a user
    When I visit user "John Doe" page
    Then I should see user "John Doe" page
    And I should not see project "Enterprise"
    And I should see project "Internal"
    And I should see project "Community"

  Scenario: I visit user "John Doe" page while signed in as someone else when he is not authorized to a public project
    Given "John Doe" owns internal project "Internal"
    And I sign in as a user
    When I visit user "John Doe" page
    Then I should see user "John Doe" page
    And I should not see project "Enterprise"
    And I should see project "Internal"
    And I should not see project "Community"

  Scenario: I visit user "John Doe" page while signed in as someone else when he is not authorized to a project I can see
    Given I sign in as a user
    When I visit user "John Doe" page
    Then I should see user "John Doe" page
    And I should not see project "Enterprise"
    And I should not see project "Internal"
    And I should not see project "Community"

  # Signed in as the user himself

  Scenario: I visit user "John Doe" page while signed in as "John Doe" when he has a public project
    Given "John Doe" owns internal project "Internal"
    And "John Doe" owns public project "Community"
    And I sign in as "John Doe"
    When I visit user "John Doe" page
    Then I should see user "John Doe" page
    And I should see project "Enterprise"
    And I should see project "Internal"
    And I should see project "Community"

  Scenario: I visit user "John Doe" page while signed in as "John Doe" when he has no public project
    Given I sign in as "John Doe"
    When I visit user "John Doe" page
    Then I should see user "John Doe" page
    And I should see project "Enterprise"
    And I should not see project "Internal"
    And I should not see project "Community"

  Scenario: I unsubscribe from admin notifications
    Given I sign in as "John Doe"
    When I visit unsubscribe link
    Then I should see unsubscribe text and button
    And I press the unsubscribe button
    Then I should be unsubscribed

  @javascript
  Scenario: "John Doe" contribution profile
    Given I sign in as a user
    And "John Doe" has contributions
    When I visit user "John Doe" page
    Then I should see user "John Doe" page
    And I should see contributed projects
    And I should see contributions calendar
