ActionController::Routing::Routes.draw do |map|
	map.namespace :users do |u|
	  u.resources :students, :name_prefix => nil
	  u.resources :teachers, :name_prefix => nil
	  u.resources :teacher_assistants, :name_prefix => nil
	end

	map.resources	:users
  map.resources :dashboard
  map.resources :sites
  map.resources :assignments
  map.resources :gradations, :member => { :update_grade => :post }
  map.resources :courses, :member => { :add_student => :post, :remove_student => :delete }
  map.resources :reports

  map.connect 'settings/terms', :controller => 'settings', :action => 'terms', :conditions => { :method => :get }

  map.resources :settings
	
  map.root :controller => "dashboard"
end
