ActionController::Routing::Routes.draw do |map|
	map.namespace :users do |u|
	  u.resources :students
	  u.resources :teachers
	  u.resources :teacher_assistants
	end

	map.resources	:users
  map.resources :dashboard
  map.resources :sites
  map.resources :assignments
  map.resources :gradations
  map.resources :enrollments
  map.resources :courses
	
  map.root :controller => "dashboard"
end
