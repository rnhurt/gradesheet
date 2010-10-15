# WARNING - this is a restricted report and should only be run by administrators.
# This report will reset student passwords to a randomly chosen word plus an integer
class PasswordReset

  # Build the parameter screen for this report.
	def self.get_params()
		# Build the parameter screen
		params = <<-EOS

	<form action="/reports/password_reset.pdf" method="get">
	  <fieldset>
	    <legend>Password Reset</legend>
	    
		<label>Homeroom</label>
			<select name='homeroom'>
				<option value=''>ALL</option>
    EOS
		# Add the homerooms
		Student.homerooms.each do |h|
			params += "<option value='#{h.homeroom}'>#{h.homeroom}</option>"
		end

		params += <<-EOS
			</select>
			
		<div class="spacer">
			<input class="btn positive" type="submit" value="Run Report" onclick="return confirm('*WARNING* This will change data in the system.\\nAre you sure you want to continue?');"/>
		</div>
		</fieldset>
	</form>
    EOS
	end


  # Build the report in PDF form and sent it to the users browser
  def self.draw(params)
	  if params[:homeroom].size > 0
		  students = Student.active.sorted.find_all_by_homeroom(params[:homeroom])
	  else
		  students = Student.active.sorted
	  end

	  # Create a new document
    pdf = Prawn::Document.new(:page => "LETTER")

	  # Make it so we don't have to use pdf. everywhere.  :)
	  pdf.instance_eval do

      font "Courier", :size => 10
      fill_color "000000"
      stroke_color "dddddd"

      # Build the footer
      footer margin_box.bottom_left do
        # Change the font to make the footer look nice
        font "Helvetica", :size => 7
        fill_color "555555"
        stroke_color "555555"
        stroke_horizontal_rule

        move_down(5)
        mask(:y) { text "page #{page_count}", :align => :right }
        mask(:y) { text "#{Date.today.to_s(:long)}", :align => :left }
        mask(:y) { text "** CONFIDENTIAL **", :align => :center }

        # Reset the font so that we can draw the next page
        font "Courier", :size => 10
        fill_color "000000"
        stroke_color "dddddd"
      end

      words = %w(welcome hello sunny school teacher paper notebook)

      # Build a table of students
      students.group_by(&:homeroom).sort.each do |homeroom|	
        define_grid(:columns => 2, :rows => 13)

        row = col = 0
        homeroom[1].each do |student|
          # Generate a password
          password = words[rand(words.length)] + rand(100).to_s
          
          # Check for space left on the page
          if row >= grid.rows
            start_new_page
            row = 0
          end

          # Build the cell
          cell = grid(row,col)

          # Update the users password
          student.password = password
          student.password_confirmation = password
          password = "ERROR: please change manually" unless student.save

          # Write the data into the cell
          bounding_box cell.top_left, :width => cell.width, :height => cell.height do
            #            text cell.name
            move_down 6
            text " Student Name: #{student.full_name[0..25]}"
            text "     Login ID: #{student.login}"
            text "     Homeroom: #{student.homeroom}"
            text " New Password: #{password}"

            stroke_bounds
          end

          # Advance to the next cell
          if col % 2 == 0
            col = 1
          else
            row += 1
            col = 0
          end

        end
        
        # Make a new page for the next homeroom
        start_new_page if !homeroom[0].blank?
      end

      # Deal with an empty report
      text "No students found" if students.blank?

      # Render the document
      render
	
	  end # instance_eval
  end # draw
end
