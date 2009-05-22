class GradationsController < ApplicationController
  before_filter :require_user
  append_before_filter :authorized?

  def index
  end
	
  def show
    @gradations = Course.find(params[:id], :include => [:students, :gradations])
  end

  def update
  	# FIXME: Should we remove this or wait until Rails 2.3?
  	# This functionality is handled in update_grade
#    @gradation = Gradation.find(params[:id])

#    respond_to do |format|
#      if @gradation.update_attributes(params[:gradation])
#        flash[:notice] = 'Gradation was successfully updated.'
#        format.html { redirect_to(@gradation) }
#      else
#        format.html { render :action => "edit" }
#      end
#    end
  end

	# Store the grade for a single student/assignment combination.  We are expecting
	# an AJAX call with the format below:
  #     "'student=#{student.id}&assignment=#{assignment.id}&score=' + value"
  def update_grade
  	# Find or create a new grade for this student/assignment
		@gradation = Gradation.find_or_create_by_student_id_and_assignment_id(
									params[:student], params[:assignment], :include => [:students, :assignments])

    # If the score is blank then delete the gradation row
    if params[:score].empty? 
      Gradation.destroy(@gradation)
    end
    
    # Format the SCORE as either a positive float or an upper case letter.
		if params[:score].is_a? String
			# The user entered a 'magic' letter instead of a grade
			@gradation.points_earned = params[:score].upcase	# Only store UPPER CASE
		else
			# The user entered a real number
			@gradation.points_earned = params[:score].abs			# Remove any negatives
		end

		# Save the record 		
		if !@gradation.save
			flash[:error] = 'Gradation failed to save'
			redirect_to :action => :show 
		end
 		
  end
end
