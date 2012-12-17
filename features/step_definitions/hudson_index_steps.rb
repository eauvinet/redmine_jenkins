
Then /^I should see latest build of "([^"]*?)":$/ do |job_name, table|

  exp_number      = table.hashes[0]['number']
  exp_result      = table.hashes[0]['result']
  exp_finished_at = table.hashes[0]['finished at']

  within("#latest-build-#{job_name}") do
    find(".number").should have_content(exp_number)
    find(".result").should have_content(exp_result)
    find(".finished-at").should have_content(exp_finished_at)
  end

end

Then /^I should see health reports of "([^"]*?)":$/ do |job_name, table|

  within("#job-state-#{job_name}") do
    actual = all("ul.job-health-reports li").map do |li|
      [li.text.strip]
    end
    actual = actual.unshift(['description'])

    table.diff!(actual)
  end

end

Then /^I should see artifacts of "([^"]*?)":$/ do |job_name, table|

  actual = all("#build-artifacts-list-#{job_name} li").map do |li|
    anchor = li.find("a")
    # FIXME: should not use native object..
    [anchor.native.text, anchor['href']]
  end
  actual = actual.unshift(['item', 'url'])

  table.diff!(actual)

end
