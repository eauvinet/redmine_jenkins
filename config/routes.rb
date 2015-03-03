RedmineApp::Application.routes.draw do
  match 'projects/:id/jenkins/:action', :controller => 'hudson', :via => [:get, :post]
  match 'projects/:id/jenkins_settings/:action', :controller => 'hudson_settings', :via => [:get, :put, :post]
end
