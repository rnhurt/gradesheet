class UserSession < Authlogic::Session::Base 
  logout_on_timeout true # default is false
end
