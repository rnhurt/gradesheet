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
    skills      = SupportingSkillCode.active
    cutoff_date = Date.today()

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
      skills = SupportingSkillCode.active
      @terms = school_year.terms.sort!{|a,b| a.end_date <=> b.end_date}

      # Function to generate the table containing the course grade information
      def print_grades(headers, data)
        data = [["No supporting skills"] + [""] * (headers.size-1)] if data.blank?
        
        column_widths = Hash.new
        # FIXME: The addition at the end of this is the result of Prawn 0.5.x tables
        # not knowing the proper width based on font size.  This is fixed in Prawn 0.6.x
        column_widths[0] = (bounds.width - (50 * (headers.size-1))) + (headers.size * 7.5)

        # Draw the table containing the grade totals and the skill scores
        font "#{Prawn::BASEDIR}/data/fonts/FreeSerif.ttf"
        table(
          data,
          :headers        => headers.map do |text|
            { :text => text, :font_size => 8 }
          end,
          :header_color   => 'E0E0E0',
          :font_size      => 7,
          :border_style   => :grid,
          :padding        => 2,
          :border_width   => 0.5,
          :width          => bounds.width,
          :column_widths  => column_widths)
      end

      # Function to print the table of comments
      def print_comments(data)
        data = [[""] + ["No comments"]] if data.blank?

        # Draw the table of comments by term
        table(
          data,
          :headers        => ['Comments', ''],
          :header_color   => 'E0E0E0',
          :font_size      => 7,
          :border_style   => :grid,
          :padding        => 2,
          :border_width   => 0.5,
          :width          => bounds.width,
          :column_widths  => {0=>40, 1=> (bounds.width - 40)})
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
        # and sort them by course type (taking into account any NIL course types)
        @courses.sort! { |a,b| a.course_type.nil? || b.course_type.nil? ? 0 : a.course_type.position <=> b.course_type.position }
        
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
    	  @courses.each_with_index do |course, index|

    	    # Try not to overflow into the next page
	        new_page if cursor < 200

          # Build the Course header
          data        = []
          data_hash   = {}
          comments    = []
          final_score = 0
          terms_complete = 0
          course_header = course.enrollments.select{|e| e.student_id == student.id}.first.accommodation? ? '* ' : ''
          course_header << "#{course.name}\n  #{course.teacher.full_name}"
          headers = [course_header]

          temp_data = []
          course.course_terms.each{|ct| temp_data << "ct#{ct.id}"}
          skill_score = Struct.new(:supporting_skill, *temp_data)
          
    		  # Gather the grades for each term in this course
          course.course_terms.sort!{|a,b| a.term.end_date <=> b.term.end_date}.each_with_index do |course_term, ctindex|
            # Only gather grades from completed Terms
            if course_term.term.end_date <= cutoff_date
              grade = course_term.calculate_grade(student.id)
              final_score += grade[:score].round
              terms_complete += 1
            else
              grade = {:letter => '', :score => -1 }
            end
            
            comments << [course_term.term.name, course_term.comments(student.id)]
            header = "#{course_term.term.name}\n #{grade[:letter]}"
            header << " (#{grade[:score].round}%)" if grade[:score] >= 0 && !course_term.grading_scale.simple_view
            headers << header

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

          # Add the FINAL information, only if the school year is complete
          unless terms_complete < course.course_terms.size
            # Create the "Final" header section
            final_score = final_score/terms_complete
            header = "Final\n #{final_score > 0 ? course.grading_scale.calculate_letter_grade(final_score) : 'n/a'}"
            header << " (#{final_score}%)" if final_score >= 0 && !course.grading_scale.simple_view
            headers << header

            # Create the data for the table and add one for a blank "Final" score
            data_hash.values.each{|value| data << value.to_a.insert(-1, '')}
          else
            # Create the data for the table
            data_hash.values.each{|value| data << value.to_a}
          end

          # Sort the skills alphabetically
          data.sort!{|a,b| a[0] <=> b[0]}

          # Print the course data alternately on the left & right side of the page
          if index.even? then
            bounding_box([0, @left_cursor], :width => (bounds.width / 2) - GUTTER_SIZE) do
              print_grades(headers,data)
              print_comments(comments)
            end
            move_down(GUTTER_SIZE * 2)
            @left_cursor = cursor
          else
            bounding_box([bounds.left + bounds.width / 2, @right_cursor], :width => (bounds.width / 2) - GUTTER_SIZE) do
              print_grades(headers,data)
              print_comments(comments)
            end
            move_down(GUTTER_SIZE * 2)
            @right_cursor = cursor
          end
        end	# each course

        ReportCard.print_attendance([0, @left_cursor], @terms)
        # ReportCard.print_signature_block([bounds.left + bounds.width / 2, @right_cursor])

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
          #          :height => scale.scale_ranges.size * 6.5 do
        :height => (scale.scale_ranges.size * font.height) / 2 do
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
      font "#{Prawn::BASEDIR}/data/fonts/FreeSerif.ttf", :size => 8
      column_box [0,cursor],
        :width => bounds.width,
        :height => (skills.size * font.height) / 2 do
        skills.each do |skill|
          text "  #{skill.code} - #{skill.description}"
        end
      end

      # Print the "accommodations" box
      font "Helvetica", :size => 7, :align => :left
      bounding_box([bounds.width-75, bounds.height-15], :width => 75, :height => 20) do
        fill_color "EEEEEE"
        fill_and_stroke_rectangle [bounds.left-2,bounds.top+2], bounds.width, bounds.height

        fill_color "000000"
        text "* - Accommodations and/or modifications"
      end
          
      move_down GUTTER_SIZE + font.height

    end # pdf instance
  end

  # Print the attendance information
  def self.print_attendance(position, terms)
    @pdf.instance_eval do
      # Set up the text options
      font "Helvetica", :size => 7, :align => :left

      bounding_box(position, :width => (bounds.width / 2) - GUTTER_SIZE) do
        column_widths = Hash.new
        
        # FIXME: The addition at the end of this is the result of Prawn 0.5.x tables
        # not knowing the proper width based on font size.  This is fixed in Prawn 0.6.x
        column_widths[0] = (bounds.width - (50 * (terms.size+1))) + (terms.size * 20)

        headers = ['Attendance'] + terms.map{|term| term.name} + ['Total']

        data = [
          ['Absent'] + [''] * (terms.size+1),
          ['Tardy'] + [''] * (terms.size+1),
          ['Early Dismissal'] + [''] * (terms.size+1)
        ]

        table(
          data,
          :headers        => headers.map do |text|
            { :text => text, :font_size => 8 }
          end,
          :header_color   => 'E0E0E0',
          :font_size      => 7,
          :border_style   => :grid,
          :padding        => 2,
          :border_width   => 0.5,
          :width          => bounds.width,
          :column_widths  => column_widths)
      end
    end
  end

  # Print the signature information
  def self.print_signature_block(position)
    @pdf.instance_eval do
      # Set up the text options
      font "Helvetica", :size => 7, :align => :left

      bounding_box(position, :width => (bounds.width / 2) - GUTTER_SIZE, :height => 200) do
        text 'Promoted ____________________'
        text 'Retained ____________________'
        stroke_bounds
      end
    end
  end

end
