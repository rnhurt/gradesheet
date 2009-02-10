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
			# Get a list of the cached reports
			@cached_reports = Report.find_all_by_name(params[:id])

			respond_to do |format|
				format.html	# display the parameters screen
				
				format.pdf do
					# Gather all the data we need for the report
					params[:student] = Student.find(params[:student_id])
					params[:grades] = Gradation.find_all_by_student_id(params[:student_id])
					params[:courses] = Course.find_yomama(params[:student_id])
				
					# Create a temp file to hold the report cache
					cache_file = File.new("#{RAILS_ROOT}/tmp/cache/#{params[:id]}.#{Time.now.to_s(:number)}", "w")
					params[:file_name] = cache_file.path

					# Generate the report
					@report.draw(params)
										
					# Send the PDF back to the browser for viewing
					send_data cache_file.path, 
							:filename			=> params[:id].titleize + '.pdf',
							:type					=> 'application/pdf',
							:disposition	=> 'inline'
				end
			end
		end
	end
end
