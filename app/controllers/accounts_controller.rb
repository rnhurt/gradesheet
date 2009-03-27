class AccountsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end

  def show
    redirect_back_or_default dashboard_index_url
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user # makes our views "cleaner" and more consistent

    # Since we have different types of users (Student, Teacher, etc.)
    # we have to grab the correct parms to update.
    if @user.update_attributes(params[@user[:type].downcase])
      flash[:notice] = "Account updated!"
      redirect_to '/'
    else
      render :action => :edit
    end
  end
end

