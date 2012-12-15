# $Id$
Feature: index
  show hudson jobs with latest build results

  Background:
    Given Project "eCookbook" uses "Hudson" Plugin
      And "Developer" has a permission below:
        | permissions         |
        | View Hudson         |
        | Edit Hudson settings|
      And I am logged in as "dlopper" with password "foo"

  @current
  Scenario: If project has no Hudson settings, plugin show message
    When I go to Hudson at "eCookbook" Project
    Then show me the page
    Then I should see "No settings for this project. Please confirm settings"

    When I click "confirm settings"
    Then I should see "Settings"

    When I fill in "http://localhost:8080" for "settings[url]"
     And I click "Save"
    Then the field named "settings[url]" should contain "http://localhost:8080/"

    When I go to Hudson at "eCookbook" Project
    Then I should see "No Jobs"

  @wip
  Scenario: Show job simple-ruby-application
    Given Project "eCookbook" uses "hudson" Plugin
      And "Developer" has a permission "view_hudson,edit_hudson_settings"
      And I log on as a User
      And I select "English" as language
      And I join "eCookbook" Project as a "Developer"
      And Hudson API returns "simple-ruby-application" as depth0
    When I go to HudsonSettings at "eCookbook" Project
     And I fill in "http://localhost:8080" for "settings[url]"
     And I press "Save"
     And I check "settings_jobs_simple-ruby-application"
     And I press "Save"

    Given Hudson API returns "simple-ruby-application" as depth1
    When I go to Hudson at "eCookbook" Project
    Then I should see "simple-ruby-application" within "#job-state-simple-ruby-application"
     And I should see "app" linked to "http://localhost:8080/job/simple-ruby-application/3/artifact/SimpleRubyApplication/source/app.rb"
     And I should see "readme" linked to "http://localhost:8080/job/simple-ruby-application/3/artifact/SimpleRubyApplication/readme.rdoc"
