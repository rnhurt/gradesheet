ActionController::Routing::Routes.draw do |map|
	map.namespace :users do |u|
	  u.resources :students, :name_prefix => nil
	  u.resources :teachers, :name_prefix => nil
	  u.resources :teacher_assistants, :name_prefix => nil
	end

#  map.resources :student do |c|
#		  c.resources :courses, :member => { :add => :post, :remove => :delete }
#  end
	
	map.resources	:users
  map.resources :dashboard
  map.resources :sites
  map.resources :assignments
  map.resources :gradations
  map.resources :courses, :member => { :add_student => :post, :remove_student => :delete }
	
  map.root :controller => "dashboard"
end
