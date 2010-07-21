# This report prints a student roster by homeroom.  It will also print
# students without a homeroom as the last page if 'ALL' is selected.
class StudentRoster

  # Build the parameter screen for this report.
	def self.get_params()	
		# Build the parameter screen
		params = <<-EOS

	<form action="/reports/student_roster.pdf" method="get">
	  <fieldset>
	    <legend>Student Roster</legend>
	    
		<label>Homeroom</label>
			<select name='homeroom'>
				<option value=''>ALL</option>
    EOS
		# Add the homerooms
		Student.homerooms.each do |h|
			params += "<option value='#{h.name}'>#{h.name}</option>"
		end

		params += <<-EOS
			</select>
			
		<div class="spacer">
			<input class="btn positive" type="submit" value="Run Report" />
		</div>
		</fieldset>
	</form>
    EOS
	end


  # Build the report in PDF form and sent it to the users browser
  def self.draw(params)
	  # Find all the students in a homeroom
	  if params[:homeroom].size > 0
		  students = Student.active.sorted.find_all_by_homeroom(params[:homeroom])
	  else
		  students = Student.active.sorted
	  end	

	  # Create a new document
    pdf = Prawn::Document.new(:page => "LETTER")

	  # Make it so we don't have to use pdf. everywhere.  :)
	  pdf.instance_eval do

      # Build the footer
      footer margin_box.bottom_left do
        font "Helvetica", :size => 7
        fill_color "555555"
        stroke_horizontal_rule

        move_down(5)
        mask(:y) { text "page #{page_count}", :align => :right }
        mask(:y) { text "#{Date.today.to_s(:long)}", :align => :left }

        font "Helvetica", :size => 10
        fill_color "000000"
      end

      # Build a table of students
      students.group_by(&:homeroom).sort.each do |homeroom|	
        # Print the HEADER
        fill_color "000000"
        stroke_color "000000"
        mask(:y) {text "Student count: #{homeroom[1].size}", :align => :right, :size => 7}
        text "Homeroom (#{homeroom[0]})", :align => :center, :size => 20
        move_down 5
		
        # Print the table of students in this homeroom
        data = homeroom[1].map { |h| ["#{h.first_name} #{h.last_name}"] }
        table data,
				  :border_style	=> :grid,
				  :vertical_padding	=> 2,
          :font_size    => 10,
				  :row_colors		=> ["DBDBDB", "FFFFFF"],
				  :width				=> bounds.width

        # Make a new page for the next homeroom
        start_new_page
      end

      # Deal with an empty report
      text "No students found" if students.blank?

      # Render the document
      render
	
	  end # instance_eval
  end # draw
end
