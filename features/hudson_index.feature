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

  Scenario: If project has no Hudson settings, plugin show message
    When I go to Hudson at "eCookbook" Project
    Then I should see "No settings for this project. Please confirm settings"

    When I click "confirm settings"
    Then I should see "Settings"

    When I fill in "http://localhost:8080" for "settings[url]"
     And I click "Save"
    Then the field named "settings[url]" should contain "http://localhost:8080/"

    When I go to Hudson at "eCookbook" Project
    Then I should see "No Jobs"

  @current
  Scenario: Show job simple-ruby-application
    Given HudsonApi.get_job_list returns "simple/hudson_job-list"
     And  HudsonApi.get_job_details returns "simple/hudson_job-details"
     And  HudsonApi.get_build_results returns "simple/job_simple-ruby-application_build_results"
    When  I go to HudsonSettings at "eCookbook" Project
     And  I fill in "http://localhost:8080" for "settings[url]"
     And  I click "Save"
     And  I check "settings_jobs_simple-ruby-application"
     And  I click "Save"

    When  I go to Hudson at "eCookbook" Project
    Then  I should see "simple-ruby-application" within "#job-state-simple-ruby-application"
     And  I should see latest build of "simple-ruby-application":
      | number | result  | finished at         |
      | 3      | SUCCESS | 2009/07/19 20:33:35 |
     And  I should see health reports of "simple-ruby-application":
      | description                                                |
      | 安定したビルド: 最近の5個中、2個ビルドに失敗しました。 59% |
      | Rcov coverage: Code coverage 70.0%(70.0) 87%               |
     And  I should see artifacts of "simple-ruby-application":
      | item   | url |
      | app    | http://localhost:8080/job/simple-ruby-application/3/artifact/SimpleRubyApplication/source/app.rb |
      | readme | http://localhost:8080/job/simple-ruby-application/3/artifact/SimpleRubyApplication/readme.rdoc |
