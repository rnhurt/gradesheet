ActionController::Routing::Routes.draw do |map|
  # Authlogic support
  map.resource :account #, :controller => "users"
  map.resource :user_session
#  map.root :controller => "user_sessions", :action => "new"

  # Since we subclass the Users into different types,
  # we need to build routes for them.
  map.namespace :users do |u|
    u.resources :students, :name_prefix => nil
    u.resources :teachers, :name_prefix => nil
    u.resources :teacher_assistants, :name_prefix => nil
   end
	
  # Settings consists of many different, often unrelated, things.  The most
  # logical way to group them together is to build individual controllers
  # and house them under the Settings "master" controller.
  map.namespace :settings do |s|
    s.resources :terms,           :name_prefix => nil
    s.resources :events,          :name_prefix => nil
    s.resources :grading_scales,  :name_prefix => nil
    s.resources :grading_skills,  :name_prefix => nil
    s.resources :sites,           :name_prefix => nil
    s.resources :imports,         :name_prefix => nil
    s.resources :assignment_categories, :name_prefix => nil
  end

	# Build the standard routes
  map.resources	:users
  map.resources :dashboard
  map.resources :assignments
  map.resources :reports
  map.resources :settings
  map.resources :grades

  # We do a couple of "special" things with these routes.  It mostly has to
  # do with AJAX updating and things like that.
  map.resources :gradations, :member => { :update_grade => :post, :update_skill => :post }
  map.resources :courses, :member => { :add_student => :post, :remove_student => :delete, :toggle_accommodation => :post }

  # By default, we want the user to see the "dashboard" page.
  map.root :controller => "dashboard"
end
