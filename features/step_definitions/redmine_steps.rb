# coding: utf-8

Given /"(.*)" has a permission below:/ do |role_name, table|
  steps %Q{
    When I am logged in as "admin" with password "admin"
     And I go to Roles
     And I click "#{role_name}"
  }
  table.hashes.each do |hash|
    steps %Q{
      When I check "#{hash['permissions']}"
    }
  end
  steps %Q{
    When I click "Save"
  }
end

Given /^Project "([^"]*?)" uses "([^"]*?)" Plugin$/ do |project_name, plugin_name|
  steps %Q{
    When I am logged in as "admin" with password "admin"
     And I go to ProjectSettings at "#{project_name}" Project
     And I click "Modules"
     And I check "#{plugin_name}"
     And I click "Save" within "div#tab-content-modules"
  }
end

Given /^Project "([^"]*?)" uses modules below:$/ do |project_name, module_names|
  steps %Q{
    When I am logged in as "admin" with password "admin"
     And I go to ProjectSettings at "#{project_name}" Project
     And I click "Modules"
  }

  module_names.hashes.each do |hash|
    steps %Q{
      When I check "#{hash['name']}"
    }
  end

  steps %Q{
     When I click "Save" within "div#tab-content-modules"
  }
end

Given /^I am logged in as "([^"]*)" with password "([^"]*)"$/ do |login_name, password|
  steps %Q{
    When I go to "login"
     And I fill in "#{login_name}" for "Login"
     And I fill in "#{password}" for "Password"
     And I click "Login »"
    Then I should see "My page"
  }
end

Given /Issue #(.*) is related to revisions "(.*)"/ do |issue_no, revisions|
  issue = Issue.find(issue_no)

  raise Exception.new("issue not found - #{issue_no}") unless issue

  revisions.split(/,/).each do |revision|
    changeset = Changeset.where(repository_id: issue.project.repository.id).
                          where(revision: revision).
                          first()
    raise Exception.new("no such changeset - #{issue.project.name} rev-#{revision}") unless changeset

    Changeset.connection.execute("INSERT INTO changesets_issues (changeset_id, issue_id) values (#{changeset.id}, #{issue.id})")
  end
end
