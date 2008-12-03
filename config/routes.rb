ActionController::Routing::Routes.draw do |map|
  map.resources :dashboard
  map.resources :sites
  map.resources :assignments
  map.resources :gradations
  map.resources :enrollments
  map.resources :courses
  map.resources :users
  map.resources :students
  map.resources :teachers
  map.resources :teacher_assistants
	
  map.root :controller => "dashboard"
end
