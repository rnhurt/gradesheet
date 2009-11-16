# This is the standard report card format and prints on US LEGAL sized paper
# by default.  It can print a single student or an array of students (i.e. a whole class)
# and will separate each report into even number of pages so that duplex 
# printing will be possible and neatly done (no odd numbered pages).
require "date"

class ReportCard

  HEADER_HEIGHT = 50  # The size of the page header
  GUTTER_SIZE   = 5   # The size of the buffer between elements
  
  # Build the parameter window to be shown to the user.	
	def self.get_params()	
		# Allow the user to select a single student or multiple students.
		students	= Student.all(:order => "last_name ASC")
		homerooms	= Student.find_homerooms()
		years = SchoolYear.all(:order => "end_date DESC")
		
    params = <<-EOS
	<form action="/reports/report_card.pdf" method="get">
	  <fieldset>
	    <legend>Report Card</legend>
	    
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
    skills = SupportingSkillCode.active

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

      # Function to generate the table containing the course grade information
      def print_data(headers, data)
        data = [["No supporting skills"] + [""] * (headers.size-1)] if data.blank?

        # Draw the table containing the grade totals and the skill scores
       font "#{Prawn::BASEDIR}/data/fonts/unifont.ttf", :size => 7  
       table(
          data,
          :headers      => headers,
          :header_color => "C0C0C0",
          :font_size    => 7,
          :border_style => :grid,
          :border_width => 0.5,
          :width        => bounds.width)
      end

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
        @courses = student.courses.by_school_year(school_year)

        # Build the page header
        header margin_box.top_left do
          font 'Helvetica', :size => 7

          # Insert the school logo
          logo = "#{RAILS_ROOT}/public/images/logo.png"
          image logo, :at => bounds.top_left, :height => 20

          # Insert the school name
          text StaticData.site_name, :align => :center, :size => 11
          text "Report Card", :align => :center, :size => 10
          
          # Insert the student information
          mask(:y) { text "Homeroom: #{student.homeroom}", :align => :center }
          mask(:y) { text "School Year: #{school_year.name}", :align => :right }
          text "Student: #{student.full_name}", :align => :left, :size => 10
          
          stroke_horizontal_rule    # make it look pretty        
          student_page_count += 1   # reset the student page counter
        end
        
        # Build the page footer
        footer margin_box.bottom_left do
          font 'Helvetica', :size => 7
          orig_fill_color = fill_color
          orig_stroke_color = stroke_color
          fill_color '555555'
          stroke_color '555555'
          stroke_horizontal_rule
    
          move_down(5)
          mask(:y) { text "page #{page_count}", :align => :right }
          mask(:y) { text Date.today.to_s(:long), :align => :left }
          fill_color orig_fill_color
          stroke_color orig_stroke_color
        end   

        # Print the grading keys & supporting skill codes
        # OPTIMIZE: There is probably a more "Ruby" way to do this...
        scales = Array.new
        @courses.each { |course| scales.push(course.grading_scale) }
        bounding_box [0, cursor - HEADER_HEIGHT], :width => bounds.width do
          ReportCard.print_skills(skills)
          ReportCard.print_keys(scales)
        end
        
        # Set the default column cursor position
        @left_cursor = cursor
        @right_cursor = cursor

        # Set up the text options
        font "Helvetica", :size => 7, :align => :left

    	  # Print the grades for each course
    	  @courses.each_with_index do |@course, index|

    	    # Try not to overflow into the next page
	        new_page if cursor < 300

          # Build the Course header
          data = []
          data_hash = {}
          course_header = @course.enrollments.select{|e| e.student_id == student.id}.first.accommodation? ? '* ' : ''
          course_header << "#{@course.name}\n  #{@course.teacher.full_name}"
          headers = [course_header]

          temp_data = []
          @course.course_terms.each{|ct| temp_data << "ct#{ct.id}"}
          skill_score = Struct.new(:supporting_skill, *temp_data)
          
    		  # Gather the grades for each term in this course
          @course.course_terms.sort!{|a,b| a.term.end_date <=> b.term.end_date}.each_with_index do |course_term, ctindex|
            grade = course_term.calculate_grade(student.id)
            header = "#{course_term.term.name}\n #{grade[:letter]}"
            header << " (#{grade[:score].round}%)" if grade[:score] >= 0 && !course_term.grading_scale.simple_view
            headers <<  header

            # Get a list of all supporting skills for all terms for this course
            course_term.course_term_skills.each do |ctskill|
              # Get the existing skill_score, or create a new one
              temp = data_hash.fetch(ctskill.supporting_skill,
                skill_score.new(ctskill.supporting_skill.description))

              # Get the score for the current course_term_skill
              temp[ctindex+1] = ctskill.score(student)

              # Store it back into the hash for data
              data_hash[ctskill.supporting_skill] = temp
            end
          end

          # Create the data for the table
          data_hash.values.each{|value| data << value.to_a}

          # Sort the skills alphabetically
          data.sort!

          # Print the course data alternately on the left & right side of the page
          if index.even? then
            bounding_box([0, @left_cursor], :width => (bounds.width / 2) - GUTTER_SIZE) do
              print_data(headers,data)
            end
            move_down(GUTTER_SIZE)
            @left_cursor = cursor
          else
            bounding_box([bounds.left + bounds.width / 2, @right_cursor], :width => (bounds.width / 2) - GUTTER_SIZE) do
              print_data(headers,data)
            end
            move_down(GUTTER_SIZE)
            @right_cursor = cursor
          end

        end	# each course

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
  	
  # Print the grading key for a specified course
  def self.print_keys(scales)
    # Check for something to print...
    return unless !scales.empty?
	  
    # Remove any duplicates
    scales.uniq!

    @pdf.instance_eval do
      # Set up the text options
      font "Helvetica", :size => 7, :align => :left

      scales.each do |scale|
        # Sort the ranges by maximum score in decreasing order
        scale.scale_ranges.sort!{|a,b| b.max_score <=> a.max_score}

        # Print the grading scale header
        text "#{scale.name}", :size => 8
        stroke_horizontal_rule
        move_down 2

        # Print the grading scale in columns 
        column_box [0,cursor],
          :width => bounds.width,
          :height => scale.scale_ranges.size * 7 do
#          :height => (scale.scale_ranges.size * font.height) / 2 do
          scale.scale_ranges.each do |range|
            text "  #{range.letter_grade} - #{range.description} (#{range.min_score}% and above)"
          end
        end
        
        move_down 7
      end
    end # instance_eval
  end


  def self.print_skills(skills)
    # Check for something to print...
    return unless !skills.empty?

    @pdf.instance_eval do
      # Set up the text options
      font "Helvetica", :size => 7, :align => :left

      # Print the skills header
      text "Supporting Skills", :size => 8
      stroke_horizontal_rule
      move_down 2

      # Print the grading scale details
      skills.each_with_index do |skill, index|
        if index.even?
          mask(:y) {
            span(bounds.width/2 - GUTTER_SIZE, :position => :left) do
              text "  #{skill.code} - #{skill.description}"
            end
          }
        else
          span((bounds.width/2) - GUTTER_SIZE, :position => :right) do
            text "  #{skill.code} - #{skill.description}"
          end
        end
      end # skills.each

      # Print the "accommodations" box
      bounding_box([bounds.width-75, bounds.height-15], :width => 75, :height => 20) do
        fill_color "EEEEEE"
        fill_and_stroke_rectangle [bounds.left-2,bounds.top+2], bounds.width, bounds.height

        fill_color "000000"
        text "* - Accommodations and/or modifications"
      end
          
      move_down GUTTER_SIZE + font.height

    end # pdf instance
  end
  
end
