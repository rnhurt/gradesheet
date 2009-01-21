class GradationsController < ApplicationController
	layout "standard"
	
  def show
    @gradation = Course.find(params[:id], :include => :assignments, :include => :students, :include => :gradations)

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
		@gradation = Gradation.find_or_create_by_student_id_and_assignment_id(params[:student], params[:assignment])

debugger
		
		# Compute the points
		if params[:score].is_a? Numeric
			# Just store the points
			@gradation.points_earned = params[:score].abs
		else case params[:score].upcase
			when 'M'
				# This is a missing assignment
				@gradation.points_earned = -1
			when 'E'
				# This is an exhusade absense
				@gradation.points_earned = -2
			end
		end

		# Save the record 		
		if !@gradation.save
			flash[:error] = 'Gradation failed to save'
			render :action => "edit"
		end
 		
  end
end
