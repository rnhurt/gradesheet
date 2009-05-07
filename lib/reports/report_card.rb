require "date"
# This is the standard report card format and prints on US LEGAL sized paper
# by default.  It can print a single student or an array of students (i.e. a whole class)
# and will separate each report into even number of pages so that duplex 
# printing will be possible and neatly done (no odd numbered pages).
class ReportCard

  # Build the parameter window to be shown to the user.	
	def self.get_params()
		# Build the parameter screen
		
		# Allow the user to select a single student or multiple students.
		students	= Student.find(:all)
		homerooms	= Student.find_homerooms()
		terms	= Term.find(:all)
		
params = <<-EOS
	<form action="/reports/report_card.pdf" method="get">
		<label><span>Grading Period</span>
		<select id="term_id" name="term_id">
EOS

		# List each active grading period
		terms.each do |t|
			params += "<option value='#{t.id}'>#{t.name}</option>"
		end

params += <<-EOS
		</select>
		</label>

    <hr />
    
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
			params += "<option value='#{s[:id]}'>#{s[:first_name]} #{s[:last_name]}</option>"
		end
				
params += <<-EOS
		</select>
		</label>

		<div class="spacer">
			<input class="btn positive" name="commit" type="submit" value="Run Report" />
		</div>
	</form>
EOS

	end
	

  # Build the report as a PDF and send it to the browser.
	def self.draw(params)	
	  # Gather the required data from the database
	  student = Student.find(params[:student_id])

    # Create a new document
    pdf = Prawn::Document.new :page_size => "LEGAL", :skip_page_creation => false

    # Make it so we don't have to use the 'pdf.' prefix everywhere.  :)
    pdf.instance_eval do
  
      # Build the header
      header margin_box.top_left do 
        font "Helvetica", :size => 7
        text "ARCHDIOCESE OF LOUISVILLE", :size => 9
        text "Report Card", :align => :center, :size => 10
        mask(:y) { text "Grade: 7S", :align => :center }
        text "Student: #{student.full_name}", :align => :left, :size => 10
      end
      # Build the footer
      footer margin_box.bottom_left do 
        font "Helvetica", :size => 7
        fill_color "555555"
        stroke_color "555555"
        stroke_horizontal_rule
  
        move_down(5)
        mask(:y) { text "page #{page_count}", :align => :right }
        mask(:y) { text Date.today.to_s(:long), :align => :left }
        fill_color "000000"
        stroke_color "000000"
      end   

    # Find out if this student has any courses in the selected grading period.
    unless student.courses.active
      bounding_box([10,bounds.height-50], :width => bounds.width-20, :height => 85) do
        stroke_rectangle [bounds.left-2,bounds.top+2], bounds.width, bounds.height
        pdf.text "No active courses", :size => 25
      end
    else  
  	  # Show grading keys
  	  bounding_box([10,bounds.height-50], :width => bounds.width-20, :height => 85) do
  		  stroke_rectangle [bounds.left-2,bounds.top+2], bounds.width, bounds.height
  
  		  font "Helvetica"
  		  text_options.update(:size => 7, :align => :left)
  		
  		  # Display the key for the grading scale used in this course
  		  bounding_box([0,bounds.height], :width => (bounds.width/2)-25, :height => bounds.height) do
          student.courses.each do |course|
            course.grading_scale.grade_ranges.each do |range|
              text "#{range.grade} - #{range.description} (#{range.min_score}% and above)"
            end
          end
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
  	  student.courses.each_with_index do |course, index|
  		  # Build the header and data information for this course
  		  headers = ["#{course.name}\n  #{course.teacher.full_name} - #{course.term.name}", "1\nA", "2\nB", "3\n ", "AVG"]
  		  data = [
  			  ["Application","A","B"," ","B"],
  			  ["Test/quizes","B","B"," ","B"],
  			  ["Test/quizes","B","B"," ","B"],
  			  ["Test/quizes","B","B"," ","B"],
  			  ["Class participation","C","C"," ","C"],
  			  ["Projects/activities","A","A"," ","A"],
  			  ["Homework","C","C"," ","C"],
  			  ["Work ethic","C","C"," ","C"],
  			  ["Behavior","C","C"," ","C"],
  			  [" "," "," "," "," "],
  			  [" "," "," "," "," "]
  		  ]
  
  		  # Print even course numbers in the left column, odd numbers in the right
  		  if index.even?
  			  mask (:y) {
  				  span(bounds.width/2, :position => :left) do
  					  table data, :headers => headers,
  						  :header_color => "C0C0C0",
  						  :font_size	=> 7,
  						  :border_style	=> :grid,
  						  :border_width	=> 0.5,
  						  :width	=> bounds.width-10
  				  end
  		  }
  		  else
  			  span(bounds.width/2, :position => :right) do
  				  table data, :headers => headers,
  					  :header_color => "C0C0C0",
  					  :font_size	=> 7,
  					  :border_style	=> :grid,
  					  :border_width	=> 0.5,
  					  :width	=> bounds.width-10
  			  end
  		  end
  		
  	  # Try not to overflow into the next page
  	  if cursor < 200
  		  start_new_page
  		  move_down 50 		# make room for the header
  	  end
  	
  	  end	# each course
    end # instance_eval
   end

  # Render the document
	pdf.render
 	
	end
end
