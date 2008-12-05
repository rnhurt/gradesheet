# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e09cdc0512f2d77a60d7ccb4c46775c1'

	def current_user
		#session[:user_id] ? @current_user ||= User.find(session[:user_id]) : nil
	end


end
