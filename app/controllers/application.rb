# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # FIXME: I don't think we want to include ALL helpers here, just possibly the application-helper
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



  #######################
  # Private methods
  private

  # Get the session object for the current user  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  # Get the current user
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  # Make sure that there is a current user.  If not, redirect the user to the
  # login page.
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  # Make sure there is not a current user.
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to dashboard_index_url
      return false
    end
  end

  # Keep the location that the user was trying to get to in-case we need to
  # redirect them
  def store_location
    session[:return_to] = request.request_uri
  end

  # Send the user to the page they were trying to get to before they were forced
  # to log in.
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  # Check to make sure the user is supposed to access this page
  def authorize
    # If this user is an Admin authorize them for everything
    # unless current_user.admin?
    
    # Check for an authorize section in the session object and build one if
    # they don't have one
    puts " **** checking for an existing session[:authorize] set ..."
    unless session[:authorize]
      puts " **** building the session[:authorize] set ..."
      case current_user.type.downcase
        when 'teacher'
          session[:authorize] = ['courses', 'assignments', 'gradations', 'reports', 'settings'].to_set
        when 'student'
          session[:authorize] = ['reports'].to_set
        else
          # unknown type of user
          session[:authorize] = [''].to_set
      end
    end
    
    # Check to make sure the user can use the requested controller
    unless session[:authorize].include?(controller_name)
      flash[:error] = "You don't have the authority to access that page"
      redirect_to dashboard_index_path
      return false
    end
  end

end
