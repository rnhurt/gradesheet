class StudentRoster

	# This report prints a student roster by homeroom.  It will also print
	# students without a homeroom as the last page if 'ALL' is selected.

	def self.get_params()
		# Get the homeroom information
		homerooms = Student.find_homerooms()
		
		# Build the parameter screen
		params = <<-EOS

	<form action="/reports/student_roster.pdf" method="get">
		<label><span class='required'>Homeroom</span>
			<select name='homeroom'>
				<option value=''>ALL</option>
EOS
		# Add the homerooms
		homerooms.each do |homeroom|
			params += "<option value='#{homeroom}'>#{homeroom}</option>"
		end

		params += <<-EOS
			</select>
		</label>
			
		<div class="spacer">
			<input class="positive" name="commit" type="submit" value="Build Roster" />
		</div>
	</form>
EOS

	end


def self.draw(params)
	# Find all the students in a homeroom
	if params[:homeroom].length > 0
		students = Student.find_all_by_homeroom(params[:homeroom])
	else
		students = Student.find(:all)
	end	

	# Create a new document
  pdf = Prawn::Document.new (:skip_page_creation => true)

	# Make it so we don't have to use pdf. everywhere.  :)
	pdf.instance_eval do

	# Build a table of students
	students.group_by(&:homeroom).sort.each do |homeroom|
		start_new_page
		# Print the HEADER
		mask(:y) { text "Date: " + Date.today.to_s(:short), :align => :left, :size => 7 }	
		mask(:y) { text "Page: " + page_count.to_s, :align => :right, :size => 7 }	
		text "Homeroom (#{homeroom[0]})", :align => :center, :size => 20
		text "Total number of students: #{homeroom[1].count}", :align => :center, :size => 7
		move_down 5
		
		data = homeroom[1].map { |h| ["#{h.first_name} #{h.last_name}"] }
		table data, 
				:border_style	=> :grid, 
				:vertical_padding	=> 2,
				:row_colors		=> ["DBDBDB", "FFFFFF"],
				:width				=> bounds.width
	end 
		
	# Render the document
	render 
	
	end # instance_eval
end # draw

end
