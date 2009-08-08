class AssignmentsController < ApplicationController
  before_filter :require_user
  append_before_filter :authorized?
  
  def show
    @course_term = CourseTerm.find(params[:id])
    @assignments = @course_term.assignments

	  respond_to do |format|
			format.html
	    format.js		{ render :partial => "assignment_list" }	# Render the list of assignments for a course
	  end
  end


  def new
    @assignment = Assignment.new
    @course_term = CourseTerm.find(params[:course_term_id])

    render :action => :edit
  end


  def edit
    @assignment = Assignment.find(params[:id])
	  @course_term = CourseTerm.find(@assignment.course_term_id)
  end


  def create
    @assignment = Assignment.new(params[:assignment])
#   	course_term = CourseTerm.find_by_course_id(params[:assignment][:course_id])
#    @course = course_term.course
#    @terms = Term.find(:all)

    respond_to do |format|
      if @assignment.save
        flash[:notice] = "Assignment '#{@assignment.name}' was created successfully."
        format.html { redirect_to :action => :show, :id => @assignment.course_term.id }
      else
        format.html { render :action => :edit }
      end
    end
  end

  def update
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment])
        flash[:notice] = "Assignment '#{@assignment.name}' was updated successfully."
        format.html { redirect_to :action => :show, :id => @assignment.course_term.id }
      else
		   	@course_term = CourseTerm.find(params[:assignment][:course_term_id])
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    
    if @assignment.destroy
      flash[:notice] = "Assignment '#{@assignment.name}' was deleted successfully."
    else
      flash[:error] = "Assignment '#{@assignment.name}' was not deleted successfully.
                        Are there assigned grades?"
    end
    
    respond_to do |format|
      format.html { redirect_to :action => 'show', :id => @assignment.course_term.id }
    end
  end
  
end
