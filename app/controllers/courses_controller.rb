class CoursesController < ApplicationController
	layout "standard"
	
  def index
    @courses = Course.find_by_owner(:all, current_user, :include => [:term])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @courses }
    end
  end

	def show
		respond_to do |format|
			format.html	{ redirect_to :action => :index }
			format.js {
				@students = Student.find_all_by_class_of(params[:value].split('||')[0])
				render :partial => "student_list"
			}
		end
	end	

  def new
    @course = Course.new
    @teacher = Teacher.find(current_user)
    @courses = Course.find_by_owner(:all, current_user)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course }
    end
  end


  def edit
    @course = Course.find(params[:id])
    @courses = Course.find_by_owner(:all, current_user, :include => [:term])
    @homerooms = Course.find_all_by_course_type_id(CourseType.find_all_by_name('Home Room'))
    
    respond_to do |format|
    	format.html
	    format.js { render :partial => "course_edit" }
	  end
  end


  def create
    @course = Course.new(params[:course])
    
    ## Force the course to be created by the current user
		@course.teacher_id = current_user.id

    respond_to do |format|
      if @course.save
        flash[:notice] = "Course '#{@course.name}' was successfully created."
	      format.html { redirect_to(courses_url) }
        format.xml  { render :xml => @course, :status => :created, :location => @course }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
debugger
    @course = Course.find(params[:id])
  #  Course.add_student(params[:student])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        flash[:notice] = "Course '#{@course.name}' was successfully updated."
	      format.html { redirect_to(courses_url) }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end


  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to(courses_url) }
      format.xml  { head :ok }
    end
  end
end
