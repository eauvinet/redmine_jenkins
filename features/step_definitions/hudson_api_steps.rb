# coding: utf-8

Given /^HudsonApi.get_job_list returns "(.*?)"$/ do |response_name|
  HudsonApi.should_receive(:get_job_list).at_least(:once).and_return(get_response("#{response_name}"))
end

def get_response(name)
  f = open "#{Rails.root}/plugins/redmine_hudson/test/responses/#{name}.xml"
  retval = f.read
  f.close
  return retval
end
