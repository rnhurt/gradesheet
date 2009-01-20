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
  	# Find any existing gradation for this student/assignment
#  	@gradation = Gradation.find(:all, :conditions => {
#  					:student_id			=> params[:student], 
#  					:assignment_id	=> params[:assignment]
# 					})
		@gradation = Gradation.find_or_create_by_student_id_and_assignment_id(params[:student], params[:assignment])
		@gradation.points_earned = params[:score]

		# Save the record 		
		if !@gradation.save
			flash[:error] = 'Gradation failed to save'
			render :action => "edit"
		end
 		
  end
end
