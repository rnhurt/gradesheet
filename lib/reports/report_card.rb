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
    @pdf = Prawn::Document.new :page_size => "LEGAL", :skip_page_creation => false

    # Make it so we don't have to use the 'pdf.' prefix everywhere.  :)
    @pdf.instance_eval do
  
      # Build the header
      header margin_box.top_left do 
        font "Helvetica", :size => 7
        text "ARCHDIOCESE OF LOUISVILLE", :size => 9
        text "Report Card", :align => :center, :size => 10
        mask(:y) { text "Grade: 7S", :align => :center }
        text "Student: #{student.full_name}", :align => :left, :size => 10
        stroke_horizontal_rule
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


      # Print the grading keys
      # FIXME: There is probably a more "Ruby" way to do this...
      scales = Array.new
      student.courses.each { |course| scales.push(course.grading_scale) }
      ReportCard.print_keys(scales)

      
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
  
  		  # Print half of the courses in the left column and the other half in the right
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

      # Always print an even number of pages.  This prevents the start of one
      # report from printing on the back of the previous report.
      start_new_page unless page_count.even?
    end # instance_eval
    
    
    # Render the document
	  @pdf.render
	end

	
	# Print the grading key for a specified course
	def self.print_keys(scales)
	  # Check for something to print...
	  return unless !scales.empty?
	  
	  # Remove any duplicates
	  scales.uniq!
    max_height = 0.0
    
    @pdf.instance_eval do    
    bounding_box [0, cursor - 50], :width => bounds.width do
    
      # Set up the text options
	    font "Helvetica"
	    text_options.update(:size => 7, :align => :left)

		
		    # Loop through each scale printing its information as we go
	      scales.each.with_index do |scale, index|
    		  if index.even?
    			  mask (:y) {
    				  span((bounds.width/2)-5, :position => :left) do
	              bounding_box([0, cursor], :width => bounds.width) do
	                # Print the name of the grading scale
	                  text "#{scale.name}", :size => font_size
	                  stroke_horizontal_rule
                  	                
                  scale.grade_ranges.each do |range|
                    text "  #{range.grade} - #{range.description} (#{range.min_score}% and above)"
                  end
          		    stroke_bounds
          		    
                  # Store the maximum height so we can move down later
                  max_height = bounds.height unless max_height > bounds.height
          		  end
    				  end
      			}
    			else
  				  span((bounds.width/2)-5, :position => :right) do
	            bounding_box([0, cursor], :width => bounds.width) do
	              # Print the name of the grading scale
	              text "#{scale.name}", :size => font_size
	              stroke_horizontal_rule
	              
                scale.grade_ranges.each do |range|
                  text "#{range.grade} - #{range.description} (#{range.min_score}% and above)"
                end
        		    stroke_bounds

                # Store the maximum height so we can move down later
                max_height = bounds.height unless max_height > bounds.height
        		  end
        		  # we are done printing in this row, move down to make room for the
        		  # next row of grading scales.
              move_down 5
  				  end
          end		      	      
            
        end          

		end

      move_down (bounds.height - cursor) - max_height
      
		end # instance_eval

		
	end

  def self.print_skills
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
	
end
