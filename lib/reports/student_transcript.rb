# This report prints a student transcript containing the students complete
# academic career.
class StudentTranscript

  # Build the parameter screen for this report.
	def self.get_params()
		# Allow the user to select a single student or multiple students.
		students	= Student.find(:all)
		homerooms	= Student.find_homerooms()

    params = <<-EOS
	<form action="/reports/student_transcript.pdf" method="get">
	  <fieldset>
	    <legend>Student Transcript</legend>

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
	  if params[:student_id].nil? then
  	  # Process a whole homeroom
  	  students = Student.find_all_by_homeroom(params[:homeroom_id])
  	else
	    # Search for individual student(s)
  	  students = Student.find(:all, :conditions => { :id => params[:student_id]})
  	end

    # Create a new document
    @pdf = Prawn::Document.new :page_size => "LETTER",
      :skip_page_creation => false,
      :page_layout => :landscape

    # Make it so we don't have to use the 'pdf.' prefix everywhere.  :)
    @pdf.instance_eval do
      # Loop through each student
      students.each_with_index do |student, sindex|

        # Count the number of pages each student requires so that we can duplex properly
        student_page_count = 0

        # Build the page header
        header margin_box.top_left do
          # Insert the school logo
          logo = "#{RAILS_ROOT}/public/images/logo.png"
          image logo, :at => bounds.top_left, :height => 35

          # Insert the school name
          text StaticData.site_name, :align => :center, :size => 11
          text "STUDENT TRANSCRIPT", :align => :center, :size => 20
          stroke_horizontal_rule    # make it look pretty

          # Insert the student information
          move_down(15)
          mask(:y) { text "Social Security No. <u><pre>" + ' '*50 + "</pre></u>",
            :align => :right, :size => 10
          }
          text "Student Name <u> #{student.full_name}<pre>" +
            ' '*(50-student.full_name.length) + "</pre></u>", :align => :left, :size => 10

          #          move_down(font.height)
          #          text "Student Address <u><pre>" + ' '*75 + "</pre></u>",
          #            :align => :left, :size => 10
          #
          #          move_down(font.height)
          #          text 'Date of Birth <u><pre>' + ' '*15 + '/' + ' '*15 + '/' + ' '*15 +
          #            '</pre></u>', :align => :left, :size => 10
          #
          #          move_down(font.height)
          #          text "Program Name <u><pre>" + ' '*75 + "</pre></u>",
          #            :align => :left, :size => 10

          student_page_count += 1   # reset the student page counter
        end

        # Set up the text options
        font "Helvetica"
        text_options.update(:size => 7, :align => :left)

        student.courses.each do |temp|
          puts "**** #{temp.name} "
        end

    	  # Print the grades for each class
   		  headers = ['School Year', 'Term', 'Course Name', 'Instructor', 'Grade']
        data = []
    	  student.courses.each_with_index do |course, index|
          data << [
            course.term.school_year,
            course.term.name,
            course.name,
            course.teacher.full_name,
            course.calculate_grade(student)[:letter]
          ]
        end	# each course

        bounding_box([0,bounds.height-75], :width => bounds.width) do
          table(
            data,
            :headers            => headers,
            :header_color       => "0000A0",
            :header_text_color  => "FFFFFF",
            :row_colors         => :pdf_writer,
            :font_size          => 7,
            :border_style       => :grid,
            :width              => bounds.width)
        end
        
        # Is this the last student?
        if sindex < students.count - 1 then
          # No, force a page break between students
          start_new_page
        else
          # Yes, make sure we don't add a page break unnecessarily
          student_page_count = 0
        end

        # Always print an even number of pages for a student.  This prevents the
        # start of one report from printing on the back of the previous report.
        start_new_page unless student_page_count.even?

      end # each student

    end # instance_eval


    # Render the document
	  @pdf.render
	end

end