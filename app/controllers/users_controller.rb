class UsersController < ApplicationController
	layout "standard"
	
  def index
    @users = User.search(params[:search], params[:page])
    @types = User.find_user_types(:all)

    respond_to do |format|
      format.html # index.html.erb
#      format.xml  { render :xml => @users }
    end
  end


	def show
#		flash[:warning] = 'Invalid Request'
#  	redirect_to :action => 'index'
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
#      format.xml  { render :xml => @user }
    end
  end


  def new
#		flash[:warning] = 'Invalid Request'
#  	redirect_to :action => 'index'
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end


  def edit
#		flash[:warning] = 'Invalid Request'
#  	redirect_to :action => 'index'
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
