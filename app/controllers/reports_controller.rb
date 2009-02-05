class ReportsController < ApplicationController
	def index
		
		respond_to do |format|
			format.html
#			format.pdf do
#					pdf = Prawn::Document.new 
#	  			pdf.text 'Hello from the ReportsController!', :size => 45
#					send_data pdf.render, :filename => 'samplereport.pdf', :type => 'application/pdf', :disposition => 'inline'
#			end

#			format.pdf { render :layout => false }

			format.pdf do 
				send_data SampleReport.draw(), :filename => 'samplereport.pdf', :type => 'application/pdf', :disposition => 'inline'
			end
		end
	end
end
