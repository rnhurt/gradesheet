class ReportCard
	# This report will print a standard report card on LEGAL sized paper.  It can
	# print a single student or an array of students (i.e. a whole class) and will
	# separate each report into even number of pages so that duplex printing will
	# be possible.
	
	def self.get_params()
		# Build the parameter screen
		
		# Allow the user to select a single student or multiple students.
		students	= Student.find(:all)
		homerooms	= Student.find_homerooms()
		
params = <<-EOS

	<form action="/reports/report_card.pdf" method="get">
		<label><span>Homeroom</span>
		<select size='1' id="homeroom_id" name="homeroom_id">
EOS

		# List each homeroom
		homerooms.each do |h|
			params += "<option value='#{h}'>#{h}</option>"
		end
		
params += <<-EOS
		</select>
		</label>

		<label><span>&nbsp;</span>
		 OR
		</label>

		<label><span>Student(s)</span>
		<select multiple size="7" id="student_id" name="student_id">
EOS

		# List all of the students in the school
		students.each do |s|
			params += "<option value='#{s[:id]}'>#{s[:first_name]}</option>"
		end
				
params += <<-EOS
		</select>
		</label>

		<div class="spacer">
			<input class="positive" name="commit" type="submit" value="Run Report" />
		</div>
	</form>
EOS

	end

	def self.draw(params)
	
	# Gather the required data from the database
		# the user info
		student = Student.find(params[:student_id], :include => :courses)
		
		# the courses they are enrolled in
		# the assignments they were responsible for
		# the grades for those assignments

	# Create a new document
  pdf = Prawn::Document.new :page_size => "LEGAL", :skip_page_creation => false

	# Make it so we don't have to use pdf. everywhere.  :)
	pdf.instance_eval do

	# Build the header
	header margin_box.top_left do 
		font "Helvetica", :size => 7
		text "ARCHDIOCESE OF LOUISVILLE", :size => 9
		text "Report Card", :align => :center, :size => 9
		mask(:y) { text "Grade: 7S", :align => :center }
		mask(:y) { text "Date Run: " + Date.today.to_s, :align => :right }
		text "Student: #{params[:student][:last_name]}, #{params[:student][:first_name]}", :align => :left
	end
	# Build the footer
	footer margin_box.bottom_left do 
		font "Helvetica", :size => 7
	 	fill_color "555555"
    stroke_horizontal_rule

    move_down(5)
    mask(:y) { text "footer", :align => :center }
    mask(:y) { text "page #", :align => :right }
    mask(:y) { text "title", :align => :left }
	end   
	
	# Show grading keys
	bounding_box([10,bounds.height-50], :width => bounds.width-20, :height => 85) do
#		fill_color "C0C0C0"
		stroke_rectangle [bounds.left-2,bounds.top+2], bounds.width, bounds.height
#		fill_color "000000"

		font "Helvetica"
		text_options.update(:size => 7, :align => :left)
		
		# Main keys
		bounding_box([0,bounds.height], :width => (bounds.width/2)-25, :height => bounds.height) do
				text "A - Understanding of subject matter and demonstration of skills is Excellent (93% and above)"
				text "B - Understanding of subject matter and demonstration of skills is Very Good (84% and above)"
				text "C - Understanding of subject matter and demonstration of skills is Adequate (75% and above)"
				text "D - Difficulty understanding of subject matter and demonstration of skills (70% and above)"
				text "U - Understanding of subject matter and demonstration of skills is Inadequate (below 70%)"
				
#			stroke_bounds
		end			
		
		# Subheadings	
		bounding_box([250,bounds.height], :width => 250, :height => bounds.height) do
			data = [
				["(+)","Exceptional performance"],
				["(b)","Satisfactory performance"],
				["(N)","Needs improvement"],
				["(NA)","Not applicable"]]
			table data,
				:vertical_padding	=> -2,
				:border_width => 0

			bounding_box([bounds.width/1.5,bounds.height-10], :width => 75, :height => 20) do
				fill_color "C0C0C0"
				fill_and_stroke_rectangle [bounds.left-2,bounds.top+2], bounds.width, bounds.height

				fill_color "000000"
				text "* - Accommodations and/or modifications"
			end
		end			
	end	

	# Print the grades for each class
	course_counter = 0
	courses = 6
	courses.times do
		# We have limited space on the page so we can only print 3 sets of 
		# grades on each page.  
		# TODO: The number of grades that will fit on a page should be dynamic,
		# 			that is a hard problem to solve and this works well enough for now.
		if course_counter.modulo(3) == 0 && course_counter > 0
			# Start a new page and move down to avoid the header
			start_new_page
			move_down 50
		end

	mask(:y) {
		# Print a class on the left side of the paper...
		span(bounds.width/2, :position => :left) do
#			headers = ["#{params[:courses][course_counter][:name]}\n#{params[:courses][course_counter][:teacher_id]}", "1", "2", "3", "AVG"]
			headers = ["SPELLING/VOCABULARY\nMrs. S. Vowels", "1", "2", "3", "AVG"]
			data = [
				["\t\tApplication","A","B"," ","B"],
				["\t\tTest/quizes","B","B"," ","B"],
				["\t\tTest/quizes","B","B"," ","B"],
				["\t\tTest/quizes","B","B"," ","B"],
				["\t\tClass participation","C","C"," ","C"],
				["\t\tProjects/activities","A","A"," ","A"],
				["\t\tHomework","C","C"," ","C"],
				["\t\tWork ethic","C","C"," ","C"],
				["\t\tBehavior","C","C"," ","C"],
				[" "," "," "," "," "],
				[" "," "," "," "," "]
			]

			table data, :headers => headers,
				:header_color => "C0C0C0",
				:font_size	=> 7,
				:border_style	=> :grid,
				:border_width	=> 0.5,
				:width	=> bounds.width-10
		end
	}
#		break if params[:courses][course_counter+1]?
		
		# Now print a class on the right hand side of the paper
		span(bounds.width/2, :position => :right) do
			headers = ["SPELLING/VOCABULARY\nMrs. S. Vowels", "1", "2", "3", "AVG"]
			data = [
				["\t\tApplication","A","B"," ","B"],
				["\t\tTest/quizes","B","B"," ","B"],
				["\t\tTest/quizes","B","B"," ","B"],
				["\t\tTest/quizes","B","B"," ","B"],
				["\t\tClass participation","C","C"," ","C"],
				["\t\tProjects/activities","A","A"," ","A"],
				["\t\tHomework","C","C"," ","C"],
				["\t\tWork ethic","C","C"," ","C"],
				["\t\tBehavior","C","C"," ","C"],
				[" "," "," "," "," "],
				[" "," "," "," "," "]
			]

			table data, :headers => headers,
				:header_color => "C0C0C0",
				:font_size	=> 7,
				:border_style	=> :grid,
				:border_width	=> 0.5,
				:width	=> bounds.width-10
		end
		course_counter += 1
	end

	start_new_page
	cell [0,bounds.height-50], :width => bounds.width,
		:text => 'YOMAMA'
	
end # instance_eval

		
	# Render the document
	pdf.render
	
	end # draw
end
