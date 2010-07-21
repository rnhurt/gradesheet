# This report prints a student transcript containing the students complete
# academic career.
class StudentTranscript

  # Build the parameter screen for this report.
	def self.get_params()
		# Allow the user to select a single student or multiple students.
		students	= Student.active.sorted
		homerooms	= Student.homerooms

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
			params += "<option value='#{h.name}'>#{h.name}</option>"
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

    params << <<-EOS
		</select>
    <br />

    <label for="orientation">Landscape?</label>
      <input type="checkbox" id="orientation" name="orientation" value="landscape" />
      <input name="orientation" type="hidden" value="portrait" />
    
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
  	  students = Student.active.sorted.find_all_by_homeroom(params[:homeroom_id])
  	else
	    # Search for individual student(s)
      students = Student.sorted.find_all_by_id(params[:student_id])
  	end

    # Create a new document
    @pdf = Prawn::Document.new :page_size => "LETTER",
      :skip_page_creation => false,
      :page_layout => params[:orientation] == "portrait" ? :portrait : :landscape

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
#          mask(:y) { text "Social Security No. <u><pre>" + ' '*(bounds.width/16) + "</pre></u>",
#            :align => :right, :size => 10
#          }
          text "Student Name <u> #{student.full_name}<pre>" +
            ' '*((bounds.width/16)-student.full_name.length) + "</pre></u>", :align => :left, :size => 10

          student_page_count += 1   # reset the student page counter
        end

        # Set up the text options
        font "Helvetica", :size => 7, :align => :left
        move_down(60)

        # Gather all the information on this students course history
        history = []
        student.courses.map { |c| history << {:year => c.school_year, :course => c} }

        # Loop through the students history, by year
        history.group_by { |record| record[:year] }.each do |year, detail|
          move_down(font.height)
          text year.name, :size => 12

          # Sort by course name...
          detail.sort! { |a,b| a[:course].name <=> b[:course].name }
          # ..then by term
          detail.sort! { |a,b| a[:course].term.begin_date <=> b[:course].term.begin_date }
          
          # Loop through each course in this year
          data = []
          detail.each do |d|
            # Build the data for the table
            data << [
              d[:course].term.name,
              d[:course].name,
              d[:course].teacher.full_name,
              d[:course].calculate_grade(student.id)[:letter]
            ]
          end

          # Print the table for this year
          table(
            data,
            :headers            => ['Term', 'Course Name', 'Instructor', 'Grade'],
            :header_color       => "0000A0",
            :header_text_color  => "FFFFFF",
            :row_colors         => :pdf_writer,
            :font_size          => 7,
            :border_style       => :grid,
            :width              => bounds.width)
        end
        
        
        # Is this the last student?
        if sindex < students.size - 1 then
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