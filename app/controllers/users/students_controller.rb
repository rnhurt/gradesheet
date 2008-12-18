class Users::StudentsController < ApplicationController
	layout "standard"


  def index
    @students = Student.search(params[:search], params[:page])

    respond_to do |format|
      format.html
      format.js { render :partial => "users/user_list", :locals => { :users => @students }}
    end
  end


  def show
		redirect_to :action => :index
  end


  def new
    @student = Student.new

    respond_to do |format|
      format.html # { redirect_to users_path }
    end
  end


  def edit
    @student = Student.find(params[:id])
    
    respond_to do |format|
    	format.html
    end
  end


  def create
    @student = Student.new(params[:student])

    respond_to do |format|
      if @student.save
        flash[:notice] = 'Student was successfully created.'
        format.html { redirect_to(@student) }
        format.xml  { render :xml => @student, :status => :created, :location => @student }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
	    	flash[:notice] = "Student  '" + @student.full_name + "'  was successfully updated."
        format.html { redirect_to(students_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @student = Student.find(params[:id])
    
    respond_to do |format|
	    if @student.destroy
	    	flash[:notice] = "Student  '" + @student.full_name + "'  was successfully deleted."
	    	format.html { redirect_to :action => :index }
#      format.html { redirect_to :action => :index }
			end
    end
  end
end
