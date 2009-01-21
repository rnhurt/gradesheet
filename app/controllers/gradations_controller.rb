class GradationsController < ApplicationController
	layout "standard"
	
  def show
    @gradation = Course.find(params[:id], :include => [:assignments, :students, :gradations])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gradation }
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


	## Update a students grade
  def update_grade
  	# Find or create a new grade
		@gradation = Gradation.find_or_create_by_student_id_and_assignment_id(
									params[:student], params[:assignment], :include => [:students, :assignments])
#debugger
		
		# Compute the points earned
		if params[:score].is_a? Numeric
			# The user entered a real number
			@gradation.points_earned = params[:score].abs	# Remove any negatives
			@gradation.flag = nil													# Reset the flag
		else
			@gradation.points_earned = nil					# Reset the points earned
			@gradation.flag = params[:score].upcase	# Force upper case
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
