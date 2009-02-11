class SimpleReport
	def self.get_params()
		# Build the parameter screen
		params = <<-EOS

	<form action="/reports/simple_report.pdf" method="get">
		<label><span class='required'>Student ID</span>
			<input class="input-text" id="student_id" name="student_id" size="30" type="text" value="343839479" />
		</label>
	
		
		<div class="spacer">
			<input class="positive" name="commit" type="submit" value="Run Report" />
		</div>
	</form>
EOS

	end

	def self.draw(params)

	puts "****** Writing file #{params[:file_name]} ********"
	
	# Create a new document
	Prawn::Document.generate(params[:file_name]) do

		text "THIS IS A SIMPLE REPORT", :size => 50, :align => :center
		
	end # generate
	end # draw
end
