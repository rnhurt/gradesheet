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
		students	= Student.active.sorted
		homerooms	= Student.homerooms
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
			params += "<option value='#{h.homeroom}'>#{h.homeroom}</option>"
		end
		
    params += <<-EOS
		</select>
		<br />
		    
		<label>OR<br /><br />Student(s)</label>
		<select multiple size="7" id="student_id" name="student_id[]">
    EOS

		# List all of the students in the school
		students.each do |s|
			params += "<option value='#{s[:id]}'>#{s[:last_name]}, #{s[:first_name]}</option>"
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
  	  students = Student.active.sorted.find_all_by_homeroom(params[:homeroom_id])
  	else
	    # Search for individual student(s)
      students = Student.sorted.find_all_by_id(params[:student_id])
  	end

    # Create a new document
    @pdf = Prawn::Document.new :page_size => "LETTER", :skip_page_creation => false

    # Make it so we don't have to use the 'pdf.' prefix everywhere.  :)
    @pdf.instance_eval do
      @initial_cursor = cursor  # Use this to reset the position on each new page
      
      # Loop through each student
      students.each_with_index do |student, sindex|
        # Get the courses this student is enrolled in for the school year
        courses = student.courses.by_school_year(school_year)
        courses.sort! { |a,b| a.course_type.nil? || b.course_type.nil? ? 0 : a.course_type.position <=> b.course_type.position }

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

          row_header = [course.name,course.teacher.full_name]
          ct_data = []

          course.course_terms.sort!{|a,b| a.term.end_date <=> b.term.end_date}.each do |course_term|
            grade = course_term.calculate_grade(student.id)
            if !grade[:desc].blank?
              temp = grade[:desc]
            else
              temp = grade[:letter]
              temp += " (#{grade[:score].round}%)" if grade[:score] >= 0 && !course_term.grading_scale.simple_view
            end
            
            ct_data << temp
          end

          data << row_header + ct_data
        end	# each course

        bounding_box([0, bounds.height-50], :width => (bounds.width)) do
          # Print the student data in table form
          headers = ["Course","Teacher"] + terms.collect{|t| t.name}
          data    = [["No grades have been recorded"] + [""] * (headers.size-1)] if data.blank?
          table(
            data,
            :headers            => headers,
            :header_color       => "00AA00",
            :header_text_color  => "ffffff",
            :border_style       => :underline_header,
            :font_size          => 7,
            :row_colors         => :pdf_writer,
            :width              => bounds.width
          )
        end

        
        start_new_page unless sindex >= students.size - 1

      end # each student
    end # instance_eval
    
    # Render the document
    @pdf.render
  end
  	
	
end
