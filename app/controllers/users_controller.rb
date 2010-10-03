class UsersController < ApplicationController
  before_filter :require_user
  before_filter :decode_user_type, :except => "modify_users"
    
  append_before_filter :authorized?
  include SortHelper

  def index
    sort_init 'last_name'
    sort_update
    params[:sort_clause] = sort_clause
    @users = @user_type.search(params)
  end


  # Show the group of users
  def show
    sort_init 'last_name'
    sort_update
    params[:sort_clause] = sort_clause
    @users = @user_type.active.search(params)
    
		render :index
  end


  def new
    @user = @user_type.new
    render :action => 'edit'
  end


  def edit
    @user = User.find(params[:id])
  end


  def create
    @user = @user_type.new(params[:user])

    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to @user
    else
      render :action => :new
    end
    
  end


  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to @user
    else
      render :action => :edit
    end
  end


  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_url
  end

  
  def impersonate
    @user = User.find(params[:id])

    if UserSession.create(@user)
      flash[:warning] = "You are now impersonating '#{@user.full_name}'."
      redirect_to root_url
    else
      flash[:error] = "Impersonation failed."
      render :action => :show
    end
  end

  def modify_users
    debugger

    puts "I got #{params[:change_to]}"
    render :nothing => true
  end

  private

  # Decode the URL to figure out what type of user we are working with
  def decode_user_type
    @user_type = params[:id].nil? ? User : params[:id].camelcase.singularize.constantize
  end
end
