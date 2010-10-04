s = Site.find_or_create_by_name 'seed site'
User.find_or_create_by_login :login => 'admin', :site => s, :password => 'password', :password_confirmation => 'password', :first_name => 'seed', :last_name => 'user', :is_admin => true
