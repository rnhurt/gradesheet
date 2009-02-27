class ReportsController < ApplicationController
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
#			# TODO: Manage a report cache
#			# Get a list of the cached reports
#			@cached_reports = Report.find_all_by_name(params[:id])
#			
#			# Get a reference to the report cache
#			Dir.mkdir("#{RAILS_ROOT}/tmp/cache/reports/") unless File.exist?("#{RAILS_ROOT}/tmp/cache/reports/")
#			cache_dir = Dir.new("#{RAILS_ROOT}/tmp/cache/reports/")

			respond_to do |format|
				format.html	do
					# display the parameters screen
#					@cached_reports = Dir.glob(cache_dir.path + "#{params[:id]}.*")
				end
				
				format.pdf do
#					# Create a file to hold the report cache
#					cache_file = File.new(cache_dir.path + "/#{params[:id]}.#{Time.now.to_s(:number)}", "w")
#					params[:file_name] = cache_file.path

#					# Generate the report
#					@report.draw(params)
										
					# Send the PDF back to the browser for viewing
#					send_file cache_file.path,
					send_data @report.draw(params),
							:filename			=> params[:id].titleize + '.pdf',
							:type					=> 'application/pdf',
							:disposition	=> 'inline'
				end
			end
		end
	end
end
