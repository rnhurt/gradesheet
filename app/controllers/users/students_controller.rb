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
		@homerooms = Student.find(:all, :select => 'homeroom', :group => 'homeroom', :conditions => "homeroom > ''").map { |h| [h.homeroom, h.homeroom] }
		
    respond_to do |format|
      format.html
    end
  end


  def edit
    @student = Student.find(params[:id])
		@homerooms = Student.find(:all, :select => 'homeroom', :group => 'homeroom', :conditions => "homeroom > ''").map { |h| [h.homeroom, h.homeroom] }
    
    respond_to do |format|
    	format.html
    end
  end


  def create
    @student = Student.new(params[:student])
		@homerooms = Student.find(:all, :select => 'homeroom', :group => 'homeroom', :conditions => "homeroom > ''").map { |h| [h.homeroom, h.homeroom] }

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
    
		## If an alternate HOMEROOM is provided then use it instead
		if !params[:homeroom1].empty?
			params[:student][:homeroom] = params[:homeroom1]
		end

    respond_to do |format|
      if @student.update_attributes(params[:student])
	    	flash[:notice] = "Student  '" + @student.full_name + "'  was successfully updated."
        format.html { redirect_to(students_url) }
      else
				@homerooms = Student.find(:all, :conditions => "homeroom > ''").map { |h| [h.homeroom, h.homeroom] }
        format.html { render :action => "edit" }
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
