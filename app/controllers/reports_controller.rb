class ReportsController < ApplicationController
	layout "standard"

	def index
	end
	
	def show
		# Since we are building the report object on the fly we need to make sure
		# that it is a valid report before we try to build/show it.	
		begin
			# Try to make the report into an 'object'
			@report = params[:id].classify.constantize
		rescue NameError
			# This is not a valid report or some other error happened
			flash[:error] = "Unknown Report '#{params[:id]}'"
			redirect_to :action => :index
		else
			# Congrtulations, it looks like this is a valid object!
			respond_to do |format|
				format.html	# display the parameters screen
				
				format.pdf do
					# Gather all the data we need for the report
					params[:student] = Student.find(params[:student_id])
#					params[:grades] = Gradation.find_all_by_student_id(params[:student_id])
#					params[:courses] = Course.find_yomama(params[:student_id])
				
					# Build the report as a PDF and send it back to the browser
					send_data @report.draw(params), 
							:filename			=> params[:id].titleize + '.pdf',
							:type					=> 'application/pdf',
							:disposition	=> 'inline'
				end
			end
		end
	end
end
