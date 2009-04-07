# FIXME: Meld all the sub-controllers (Students, Teachers, TA) into this controller
class UsersController < ApplicationController
  before_filter :require_user
  append_before_filter :authorized?

  def index
    @users = User.search(params[:search], params[:page])

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  # We don't really want to show an individual person but rather the listing
  # of all people.
  def show
		redirect_to :action => :index
  end
	def show
		redirect_to :action => :index
  end


  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end


  def edit
    @user = User.find(params[:id])
  end


  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
      else
        format.html { render :action => "new" }
      end
    end
  end


  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
      else
        format.html { render :action => "edit" }
      end
    end
  end


  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
    end
  end
end
