class Users::TeachersController < ApplicationController
  def index
    @teachers = Teacher.search(params[:search], params[:page])

    respond_to do |format|
      format.html
      format.js { render :partial => "users/user_list", :locals => { :users => @teachers } }
    end
  end


  def show
    # We don't really want to show an individual teacher but rather the listing
    # of all teachers.
    respond_to do |format|
      format.html { redirect_to :action=>:index }
    end
  end


  def new
    @teacher = Teacher.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end


  def edit
    @teacher = Teacher.find(params[:id])
  end


  def create
    @teacher = Teacher.new(params[:teacher])

    respond_to do |format|
      if @teacher.save
        flash[:notice] = "Teacher was '#{@teacher.full_name}' successfully created."
        format.html { redirect_to(teachers_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end


  def update
    @teacher = Teacher.find(params[:id])

    respond_to do |format|
      if @teacher.update_attributes(params[:teacher])
        flash[:notice] = "Teacher was '#{@teacher.full_name}' successfully updated."
        format.html { redirect_to(teachers_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end


  def destroy
    @teacher = Teacher.find(params[:id])
    @teacher.destroy

    respond_to do |format|
      format.html { redirect_to(teachers_url) }
      format.xml  { head :ok }
    end
  end
end
