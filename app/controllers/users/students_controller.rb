class Users::StudentsController < ApplicationController
  before_filter :require_user
  append_before_filter :authorized?
  include SortHelper

  def index
    sort_init 'last_name'
    sort_update
    params[:sort_clause] = sort_clause
    @students = Student.search(params)

    respond_to do |format|
      format.html
      format.js { render :partial => "users/user_list", :locals => { :users => @students }}
    end
  end


  # We don't really want to show an individual person but rather the listing
  # of all people.
  def show
		redirect_to :action => :index
  end


  def new
    @student = Student.new
    @homerooms = Student.homerooms
 		
		render :action => :edit
  end


  def edit
    @student = Student.find(params[:id])
    @homerooms = Student.homerooms
  end


  def create
    @student = Student.new(params[:student])
    @homerooms = Student.homerooms

      if @student.save
        flash[:notice] = 'Student was successfully created.'
        redirect_to @student
      else
        render :action => :edit
    end
  end


  def update
    @student = Student.find(params[:id])
    
		## If an alternate HOMEROOM is provided then use it instead		
    params[:student][:homeroom] = params[:homeroom1] if !params[:homeroom1].empty?

    if @student.update_attributes(params[:student])
      flash[:notice] = "Student  '" + @student.full_name + "'  was successfully updated."
      redirect_to students_url
    else
      @homerooms = Student.homerooms
      render :action => "edit"
    end
  end

  
  def destroy
    @student = Student.find(params[:id])
    
    if @student.destroy
      flash[:notice] = "Student  '" + @student.full_name + "'  was successfully deleted."
      redirect_to :action => :index
    end
  end
end
