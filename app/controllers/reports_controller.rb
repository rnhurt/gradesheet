class ReportsController < ApplicationController
	layout "standard"

	def index
		
		respond_to do |format|
			format.html

#			format.pdf do 
#				send_data SampleReport.draw(), :filename => 'samplereport.pdf', :type => 'application/pdf', :disposition => 'inline'
#			end
		end
	end
	
	def show
		respond_to do |format|
			format.html	do
				flash[:notice] = "Can't build report '#{params[:id]}'"
				redirect_to :action => :index
			end

			format.pdf do
				begin
					# Make sure that this is a valid report
					report = params[:id].classify.constantize
				rescue NameError
					# Inform the user of the error
					flash[:error] = "Unknown Report '#{params[:id]}'"
					redirect_to :action => :index
				else
					# Build the report and send it back to the browser
					send_data report.draw(params), 
							:filename			=> params[:id].titleize + '.pdf',
							:type					=> 'application/pdf',
							:disposition	=> 'inline'
				end
			end
		end
	end
end
