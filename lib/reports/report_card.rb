require "date"
# This is the standard report card format and prints on US LEGAL sized paper
# by default.  It can print a single student or an array of students (i.e. a whole class)
# and will separate each report into even number of pages so that duplex 
# printing will be possible and neatly done (no odd numbered pages).
class ReportCard

  HEADER_HEIGHT = 50  # The size of the page header
  GUTTER_SIZE   = 5   # The size of the buffer between elements
  
  # Build the parameter window to be shown to the user.	
	def self.get_params()
		# Build the parameter screen
		
		# Allow the user to select a single student or multiple students.
		students	= Student.find(:all)
		homerooms	= Student.find_homerooms()
		terms	= Term.find(:all)
		
params = <<-EOS
	<form action="/reports/report_card.pdf" method="get">
	  <fieldset>
	    <legend>Report Card</legend>
	    
		<label>Grading Period</label>
		<select id="term_id" name="term_id">
EOS

		# List each active grading period
		terms.each do |t|
			params += "<option value='#{t.id}'>#{t.name}</option>"
		end

params += <<-EOS
		</select>

    <hr />
    
		<label>Homeroom</label>
		<select size='1' id="homeroom_id" name="homeroom_id">
EOS

		# List each homeroom
		homerooms.each do |h|
			params += "<option value='#{h}'>#{h}</option>"
		end
		
params += <<-EOS
		</select>
		<br />
		    
		<label>OR<br /><br />Student(s)</label>
		<select multiple size="7" id="student_id" name="student_id[]">
EOS

		# List all of the students in the school
		students.each do |s|
			params += "<option value='#{s[:id]}'>#{s[:first_name]} #{s[:last_name]}</option>"
		end
				
params += <<-EOS
		</select>

		<div class="spacer">
			<input class="btn positive" name="commit" type="submit" value="Run Report" />
		</div>
		
		</fieldset>
	</form>
EOS

	end
	

  # Build the report as a PDF and send it to the browser.
	def self.draw(params)
	  # Gather the required data from the database
	  term = Term.find(params[:term_id])

	  if params[:student_id].nil? then
  	  # Process a whole homeroom
  	  students = Student.find_all_by_homeroom(params[:homeroom_id])
  	else
	    # Search for individual student(s)
  	  students = Student.find(:all, :conditions => { :id => params[:student_id]})
  	end

    # Create a new document
    @pdf = Prawn::Document.new :page_size => "LEGAL", :skip_page_creation => false

    # Make it so we don't have to use the 'pdf.' prefix everywhere.  :)
    @pdf.instance_eval do
      @initial_cursor = cursor  # Use this to reset the position on each new page

      # Generate the table containing the course grade information
      def make_table(headers, data)
        table(
          data,
          :headers      => headers,
          :header_color => "C0C0C0",
          :font_size    => 7,
          :border_style => :grid,
          :border_width => 0.5,
          :width        => bounds.width)
      end

      # Generate a new page for the report.
      def new_page
        # Reset the column cursor positions whenever we start a new page
        @left_cursor = @initial_cursor - HEADER_HEIGHT
        @right_cursor = @initial_cursor - HEADER_HEIGHT
        
        # Trigger a new page
        start_new_page          
      end
      
      # Loop through each student
      students.each_with_index do |student, sindex|

        # Count the number of pages each student requires so that we can duplex properly
        student_page_count = 0
                  
        # Build the page header
        header margin_box.top_left do
          # Insert the school logo
          logo = "public/images/logo.png"
          image logo, :at => bounds.top_left, :height => 20

          # Insert the school name
          text SITE_NAME, :align => :center, :size => 11
          text "Report Card", :align => :center, :size => 10
          
          # Insert the student information
          mask(:y) { text "Homeroom: #{student.homeroom}", :align => :center }
          mask(:y) { text "Term: #{term.name}", :align => :right }
          text "Student: #{student.full_name}", :align => :left, :size => 10
          
          stroke_horizontal_rule    # make it look pretty        
          student_page_count += 1   # reset the student page counter
        end
        
        # Build the page footer
        footer margin_box.bottom_left do 
          font "Helvetica", :size => 7
          orig_fill_color = fill_color
          orig_stroke_color = stroke_color
          fill_color "555555"
          stroke_color "555555"
          stroke_horizontal_rule
    
          move_down(5)
          mask(:y) { text "page #{page_count}", :align => :right }
          mask(:y) { text Date.today.to_s(:long), :align => :left }
          fill_color orig_fill_color
          stroke_color orig_stroke_color
        end   

        # Print the grading keys
        # FIXME: There is probably a more "Ruby" way to do this...
        scales = Array.new
        student.courses.each { |course| scales.push(course.grading_scale) }
        ReportCard.print_keys(scales)

        # Set the default column cursor position
        @left_cursor = cursor
        @right_cursor = cursor

        # Set up the text options
        font "Helvetica"
        text_options.update(:size => 7, :align => :left)
        
    	  # Print the grades for each class
    	  student.courses.each_with_index do |course, index|

    	    # Try not to overflow into the next page
	        new_page if cursor < 300

    		  # Build the header and data information for this course
    		  headers = ["#{course.name} - #{course.term.name}\n  #{course.teacher.full_name}", "A(93%)", "B(86%)", "n/a", "B(90%)"]
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
    			  ["Work ethic","C","C"," ","C"],
    			  ["Behavior","C","C"," ","C"],
    			  ["Work ethic","C","C"," ","C"],
    			  ["Behavior","C","C"," ","C"],
    			  ["Work ethic","C","C"," ","C"],
    			  ["Behavior","C","C"," ","C"],
    			  ["Work ethic","C","C"," ","C"],
    			  ["Behavior","C","C"," ","C"],
    			  [" "," "," "," "," "],
    			  [" "," "," "," "," "]
    		  ]


          # Print the course data alternately on the left & right side of the page
          if index.even? then
            bounding_box([0, @left_cursor], :width => (bounds.width / 2) - GUTTER_SIZE) do
              make_table(headers,data)
            end
            move_down(GUTTER_SIZE)
            @left_cursor = cursor
          else
            bounding_box([bounds.left + bounds.width / 2, @right_cursor], :width => (bounds.width / 2) - GUTTER_SIZE) do
              make_table(headers,data)
            end
            move_down(GUTTER_SIZE)
            @right_cursor = cursor
          end

        end	# each course

        # Is this the last student?
        if sindex < students.count - 1 then
          # No, force a page break between students
          new_page
        else
          # Yes, make sure we don't add a page break unnecessarily
          student_page_count = 0
        end

        # Always print an even number of pages for a student.  This prevents the
        # start of one report from printing on the back of the previous report.
        new_page unless student_page_count.even?
        
      end # each student
                  
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
      
    @pdf.instance_eval do
      pad_bottom(0) do
        bounding_box [0, cursor - HEADER_HEIGHT], :width => bounds.width do

          # Set up the text options
    	    font "Helvetica"
    	    text_options.update(:size => 7, :align => :left)

          scales.each do |scale|
            # Print the grading scale header
            text "#{scale.name}", :size => 8
            stroke_horizontal_rule
            move_down 2

            # Print the grading scale details
            scale.grade_ranges.each_with_index do |range, index|
              if index.even?
                mask(:y) {
                  span(bounds.width/2 - GUTTER_SIZE, :position => :left) do
                    text "  #{range.grade} - #{range.description} (#{range.min_score}% and above)"            
                  end
                }
              else
                span((bounds.width/2) - GUTTER_SIZE, :position => :right) do
                  text "  #{range.grade} - #{range.description} (#{range.min_score}% and above)"
                end
              end
            end # grade_range.each

            move_down GUTTER_SIZE + 20
          end
        end # bounding_box
      end # pad_bottom
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
