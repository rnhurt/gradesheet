# Create a new default site
site = Site.find_or_create_by_name 'Main'

# Add the admin user
User.find_or_create_by_login :login => 'admin', :site => site,
  :password => 'password', :password_confirmation => 'password',
  :first_name => 'admin', :last_name => 'user', :is_admin => true
