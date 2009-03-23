# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e09cdc0512f2d77a60d7ccb4c46775c1'

  # Authlogic
  filter_parameter_logging  :password, :password_confirmation
  helper_method :current_user_session, :current_user

	
  ## Declare exception to handler methods
  rescue_from ActiveRecord::RecordNotFound, :with => :bad_record
#  rescue_from NoMethodError, :with => :show_error

  def bad_record
    flash[:warning] = 'Record could not be found.  Please try again.'
    redirect_to :action => :index
  end
  def show_error(exception); render :text => exception.message; end

	# This method was built to overcome a weakness in current_page? as reported
	# in http://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/805
	def my_current_controller?(c)
		controller.controller_name == c
	end

  #######################
  # Private methods
  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

end
