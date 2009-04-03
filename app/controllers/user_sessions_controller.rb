class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to dashboard_index_url
    else
      flash[:error] = "Login failed!"
      redirect_to new_user_session_url
    end
  end

  def destroy
    current_user_session.destroy
    session[:authorize] = nil   # remove the users authority
    flash[:notice] = "Logout successful!"
    redirect_to dashboard_index_url
  end

end
