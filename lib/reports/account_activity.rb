# This report prints a student roster by homeroom.  It will also print
# students without a homeroom as the last page if 'ALL' is selected.
class AccountActivity

  # Build the parameter screen for this report.
	def self.get_params()
		# Build the parameter screen
		params = <<-EOS

	<form action="/reports/account_activity.pdf" method="get">
	  <fieldset>
	    <legend>Account activity</legend>
	    
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

      site_name = StaticData.site_name
      fill_color "000000"

      # Build the page header
      header margin_box.top_left do
        fill_color "333333"

        # Insert the school logo
        logo = "#{RAILS_ROOT}/public/images/logo.png"
        image logo, :at => bounds.top_left, :height => 35

        # Insert the school name
        text site_name,  :align => :center, :size => 11
        text "ACCOUNT ACTIVITY",    :align => :center, :size => 20
        stroke_horizontal_rule    # make it look pretty
      end

      # Build the footer
      footer margin_box.bottom_left do
        font "Helvetica", :size => 7
        fill_color "555555"
        stroke_horizontal_rule

        move_down(5)
        mask(:y) { text "page #{page_count}",         :align => :right }
        mask(:y) { text "#{Date.today.to_s(:long)}",  :align => :left }
      
        fill_color "000000"
      end

      # Build a table of students
      data = []
      students.each do |student|
        data << [
          student.login,
          student.full_name,
          student.login_count,
          student.last_request_at.blank? ? 'never' : student.last_request_at.to_s(:long)
        ]
      end

      # Display the data in a pretty way
      bounding_box [margin_box.left, margin_box.top - 50],
        :width  => margin_box.width,
        :height => margin_box.height - 60 do

        # Check for valid data
        if students.blank?
          text "No students found"
        else
          table data,
            :headers            => ['Login ID', 'Student Name', 'Login Count', 'Last Login Date'],
            :header_color       => "00AA00",
            :header_text_color  => "ffffff",
            :border_style       => :underline_header,
            :font_size          => 7,
            :row_colors         => :pdf_writer,
            :width              => bounds.width,
            :align              => {0 => :center, 1 => :left, 2 => :center, 3 => :center}
        end
      end

      # Render the document
      render
	
    end # instance_eval
  end # draw
end
