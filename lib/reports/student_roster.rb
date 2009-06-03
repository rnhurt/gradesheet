# This report prints a student roster by homeroom.  It will also print
# students without a homeroom as the last page if 'ALL' is selected.
class StudentRoster

  # Build the parameter screen for this report.
	def self.get_params()
		# Get the homeroom information
		homerooms = Student.find_homerooms()
		
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
		homerooms.each do |homeroom|
			params += "<option value='#{homeroom}'>#{homeroom}</option>"
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
	  if params[:homeroom].length > 0
		  students = Student.find_all_by_homeroom(params[:homeroom])
	  else
		  students = Student.find(:all)
	  end	

	  # Create a new document
    pdf = Prawn::Document.new(:skip_page_creation => true, :page => "LETTER")

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
	  end   

	  # Build a table of students
	  students.group_by(&:homeroom).sort.each do |homeroom|
		  start_new_page
		
		  # Print the HEADER
		  fill_color "000000"
		  stroke_color "000000"
		  mask(:y) {text "Student count: #{homeroom[1].count}", :align => :right, :size => 7}
		  text "Homeroom (#{homeroom[0]})", :align => :center, :size => 20
		  move_down 5
		
		  # Print the table of students in this homeroom
		  data = homeroom[1].map { |h| ["#{h.first_name} #{h.last_name}"] }
		  table data, 
				  :border_style	=> :grid, 
				  :vertical_padding	=> 2,
				  :row_colors		=> ["DBDBDB", "FFFFFF"],
				  :width				=> bounds.width
	  end 
	
	  # Render the document
	  render 
	
	  end # instance_eval
  end # draw

end
