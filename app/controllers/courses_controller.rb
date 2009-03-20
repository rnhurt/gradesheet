class CoursesController < ApplicationController
  def index
    respond_to do |format|
      format.html
    end
  end

	def show
		# Displays the students enrolled in each course.
    @course = Course.find(params[:id])
    @homerooms = Student.find_homerooms()

		respond_to do |format|
			format.html
			format.js {
				# The format of the params[value] is studentid||header name||type.  This
				# allows us to load the proper list of students and label the table
				# header with something appropriate.  It is a hack and I'm sure there
				# is a better way to do this.
				value = params[:value].split('||')
				if value.pop == 'H' then
					# Find students by "Home Room"
					@students = Student.find_all_by_homeroom(value[0])
				else
					# Find students by "Class Of"
					@students = Student.find_all_by_class_of(value[0])
				end
				render :partial => "student_list"
			}
		end
	end	


  def new
    @course = Course.new
    @teacher = Teacher.find(current_user)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course }
    end
  end


  def edit
    @course = Course.find(params[:id])
#    @homerooms = Course.find_all_by_course_type_id(CourseType.find_all_by_name('Home Room'))
    
    respond_to do |format|
    	format.html
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
      else
        format.html { render :action => "new" }
      end
    end
  end


  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        flash[:notice] = "Course '#{@course.name}' was successfully updated."
	      format.html { redirect_to(courses_url) }
	      format.js { render :action => "update" }
      else
        flash[:error] = "Course '#{@course.name}' failed to update."
        format.html { redirect_to(:action => :show) }
      end
    end
  end


  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to(courses_url) }
    end
  end

  
 	# Add student(s) to a course  
  def add_student
		@course = Course.find(params[:id]) 

    # Are we adding one student or an array of students?
    if params[:students]
      # Add all the students to the course
      students = Student.find(params[:students])
      students.each do |student|
        begin
          @course.students << student
        rescue ActiveRecord::RecordInvalid
          # This is here to catch an existing student being added to a course
        end
      end
      @course.save
    else
      # Add a single student to the course and save it
  		@student = Student.find(params[:student_id])    	
  	  @add = true
		  
   		if @course.students.index(@student) == nil
	      @course.students << @student
	      @course.save
      end
    end
    
   	render :action => "modify", :locals => { :add => true }
  end

  # Remove a student from a course
  def remove_student
 		@course = Course.find(params[:id])
 		@student = Student.find(params[:student_id])
 		@add = false
 		if @course.students.index(@student) != nil
	    @course.students -= [@student]
  	  @course.save
  	end
   	render :action => "modify", :locals => { :add => false }
  end
end
