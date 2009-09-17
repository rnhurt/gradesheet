# This is the standard report card format and prints on US LEGAL sized paper
# by default.  It can print a single student or an array of students (i.e. a whole class)
# and will separate each report into even number of pages so that duplex 
# printing will be possible and neatly done (no odd numbered pages).
require "date"

class ProgressReport

  HEADER_HEIGHT = 50  # The size of the page header
  GUTTER_SIZE   = 5   # The size of the buffer between elements
  
  # Build the parameter window to be shown to the user.	
	def self.get_params()	
		# Allow the user to select a single student or multiple students.
		students	= Student.all(:order => "last_name ASC")
		homerooms	= Student.find_homerooms()
		years = SchoolYear.all(:order => "end_date DESC")
		
    params = <<-EOS
	<form action="/reports/progress_report.pdf" method="get">
	  <fieldset>
	    <legend>Progress Report</legend>
	    
		<label>School Year</label>
		<select id="school_year_id" name="school_year_id">
    EOS

		# List each active grading period
		years.each do |year|
			params += "<option value='#{year.id}'>#{year.name}</option>"
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
	  school_year = SchoolYear.find(params[:school_year_id])

	  if params[:student_id].nil? then
  	  # Process a whole homeroom
  	  students = Student.find_all_by_homeroom(params[:homeroom_id])
  	else
	    # Search for individual student(s)
  	  students = Student.find(:all, :conditions => { :id => params[:student_id]})
  	end

    # Create a new document
    @pdf = Prawn::Document.new :page_size => "LETTER", :skip_page_creation => false

    # Make it so we don't have to use the 'pdf.' prefix everywhere.  :)
    @pdf.instance_eval do
      @initial_cursor = cursor  # Use this to reset the position on each new page

      # Function to generate a new page for the report.
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

        # Get the courses this student is enrolled in for the school year
        courses = student.courses.by_school_year(school_year)
        terms = school_year.terms.sort!{|a,b| a.end_date <=> b.end_date}

        # Build the page header
        header margin_box.top_left do
          # Insert the school logo
          logo = "#{RAILS_ROOT}/public/images/logo.png"
          image logo, :at => bounds.top_left, :height => 20

          # Insert the school name
          text StaticData.site_name, :align => :center, :size => 11
          text "Progress Report", :align => :center, :size => 10
          
          # Insert the student information
          mask(:y) { text "Homeroom: #{student.homeroom}", :align => :center }
          mask(:y) { text "School Year: #{school_year.name}", :align => :right }
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
        # OPTIMIZE: There is probably a more "Ruby" way to do this...
        scales = Array.new
        courses.each { |course| scales.push(course.grading_scale) }

        # Set up the text options
        font "Helvetica", :size => 7, :align => :left

    	  # Print the grades for each course
        data = []
        row_header = []
    	  courses.each_with_index do |course, index|

    	    # Try not to overflow into the next page
	        new_page if cursor < 300

          row_header = [[course.name],[course.teacher.full_name]]
          ct_data = []

          course.course_terms.sort!{|a,b| a.term.end_date <=> b.term.end_date}.each do |course_term|
            grade = course_term.calculate_grade(student.id)
            temp = grade[:letter]
            temp += " (#{grade[:score].round}%)" if grade[:score] >= 0 && !course_term.grading_scale.simple_view
            ct_data << temp
          end

          data << row_header + ct_data
        end	# each course

        bounding_box([0, bounds.height-50], :width => (bounds.width)) do
          # Print the student data in table form
          table(
            data,
            :headers            => [["Course"],["Teacher"]] + terms.collect{|t| [t.name]},
            :header_color       => "00AA00",
            :header_text_color  => "ffffff",
            :border_style       => :underline_header,
            :font_size          => 7,
            :row_colors         => :pdf_writer,
            :width              => bounds.width
          )
        end

        # Is this the last student?
        if sindex < students.size - 1 then
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
  	
	
end
