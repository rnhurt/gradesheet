ActionController::Routing::Routes.draw do |map|
  map.resources :sites
  map.resources :assignments
  map.resources :gradations
  map.resources :enrollments
  map.resources :teachers
  map.resources :courses
  map.resources :students
  map.resources :dashboard

  map.root :controller => "dashboard"
end
