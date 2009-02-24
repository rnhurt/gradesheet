class GradationsController < ApplicationController
	layout "standard"

  def index
  end
	
  def show
    @gradations = Course.find(params[:id], :include => [:students, :gradations])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def update
  	## This functionality is handled in update_grade
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


  def update_grade
  	# Store the grade for a single student/assignment combination.  We are expecting
  	# an AJAX call with the format below:
    #     "'student=#{student.id}&assignment=#{assignment.id}&score=' + value"

  	# Find or create a new grade for this student/assignment
		@gradation = Gradation.find_or_create_by_student_id_and_assignment_id(
									params[:student], params[:assignment], :include => [:students, :assignments])

		# Compute the points earned
		if params[:score].is_a? Numeric
			# The user entered a real number
			@gradation.points_earned = params[:score].abs			# Remove any negatives
		else
			# The user entered a 'magic' letter instead of a grade
			@gradation.points_earned = params[:score].upcase	# Only store UPPER CASE
		end

		# Save the record 		
		if !@gradation.save
			flash[:error] = 'Gradation failed to save'
			respond_to do |format|
				format.js	{ redirect_to :action => :show }
			end
		end
 		
  end
end
