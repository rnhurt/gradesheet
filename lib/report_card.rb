class ReportCard
	def self.draw(params)

	# Create a new document
  pdf = Prawn::Document.new 

	# Make it so we don't have to use pdf. everywhere.  :)
	pdf.instance_eval do


	# Build the header
	header margin_box.top_left do 
		font "Helvetica", :size => 7
		text "ARCHDIOCESE OF LOUISVILLE", :size => 9
		text "Report Card", :align => :center, :size => 9
		mask(:y) { text "Grade: 7S", :align => :center }
		mask(:y) { text "Date Run: " + Date.today.to_s, :align => :right }
		text "Student: Bob Smith", :align => :left
	end
	# Build the footer
	footer margin_box.bottom_left do 
		font "Helvetica", :size => 7
	 	fill_color "555555"
    stroke_horizontal_rule

    move_down(5)
    mask(:y) { text "footer", :align => :center }
    mask(:y) { text "page #", :align => :right }
    mask(:y) { text "title", :align => :left }
	end   

	bounding_box([10,670], :width => 250, :height => 500) do
		font "Helvetica"
		text_options.update(:size => 7, :align => :left)
		bounding_box([0,bounds.height], :width => 250, :height => bounds.height) do
			data = [["A -","Understanding of subject matter and demonstration of skills is Excellent (93% and above)"]]
			table data,
				:vertical_padding	=> -2,
				:border_width => 0.5
				
		end			
			
	stroke_bounds			
#			"Understanding of subject matter and demonstration of skills is Excellent (93% and above)"}
	end	
	
	
	end # instance_eval
	


#	# Show Grading Scales
#	pdf.line_width = 0.5
#	pdf.text_options.update(:size => 7, :align => :left)
#  pdf.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"

#	pdf.bounding_box([10,670], :width => 500, :height => 70) do
#		# Draw Achievement Key
#		pdf.bounding_box([0,pdf.bounds.height], :width => 250, :height => pdf.bounds.height) do
#			pdf.move_down(5)
#			pdf.text " Achievement Grade Key"
#			data = [
#						["A =", "Execellent, Exceptional"],
#						["B =","Very Good"],
#						["C =","Satisfactory"],
#						["D =","Needs Improvement"],
#						["U =","Unsatisfactory"]
#				]
#			pdf.table data, 
#							:border_width			=> 0,
#							:vertical_padding	=> -2
#		end
#		pdf.stroke_bounds					  
#		
#		# Draw Standards Key
#		pdf.bounding_box([250,pdf.bounds.height], :width => 250, :height => pdf.bounds.height) do
#			pdf.move_down(5)
#			pdf.text " Standards Key"
#			data = [
#						["* =", "Execellent, Exceptional"],
#						["+ =","Very Good"],
#						["/ =","Satisfactory"],
#						["- =","Needs Improvement"],
#						["  =","Not Accessed at this time"]
#				]
#			pdf.table data, 
#							:border_width			=> 0,
#							:vertical_padding	=> -2
#		end
#	end

#	# Draw Content Standards
#	pdf.bounding_box([10,595], :width => 500, :height => 100) do
#		# Draw Header
#		pdf.bounding_box([0,pdf.bounds.height], :width => pdf.bounds.width, :height => 15) do
#			pdf.fill_color "C0C0C0"
#			pdf.stroke_color "000000"
#      pdf.fill_and_stroke_rectangle pdf.bounds.top_left, pdf.bounds.width, pdf.bounds.height

#			pdf.move_down(3)
#			pdf.fill_color "000000"
#			pdf.text "Content Standards - Grade Level Exit Expectations", :size => 9, :bold => true, :align => :center
#		end
#		
#		# Draw Skills - Left Side
#		pdf.bounding_box([0,pdf.bounds.height-18], :width => 248, :height => 50) do
#			# Draw Header
#			pdf.bounding_box([0,pdf.bounds.height], :width => pdf.bounds.width, :height => 10) do
#				pdf.fill_color "C0C0C0"
#				pdf.stroke_color "000000"
#	      pdf.fill_and_stroke_rectangle pdf.bounds.top_left, pdf.bounds.width, pdf.bounds.height

##				pdf.move_down(3)
#				pdf.fill_color "000000"
#				pdf.text "Mathmatics", :size => 6, :align => :center
#				
#				data = ["Achievement", "A", "B", "A"," "],["Special", "A", "B", "A"," "]
#				pdf.table data,
#							:border_width			=> 0,
#							:vertical_padding	=> -2
#			end
#		end


#		# Draw Skills - Right Side
#		pdf.bounding_box([252,pdf.bounds.height-18], :width => 248, :height => 10) do
#			# Draw Header
#			pdf.bounding_box([0,pdf.bounds.height], :width => pdf.bounds.width, :height => 10) do
#				pdf.fill_color "C0C0C0"
#				pdf.stroke_color "000000"
#	      pdf.fill_and_stroke_rectangle pdf.bounds.top_left, pdf.bounds.width, pdf.bounds.height

##				pdf.move_down(3)
#				pdf.fill_color "000000"
#				pdf.text "Social Studies", :size => 6, :align => :center
#			end
#		end
#		
#		pdf.stroke_bounds
#	end

	# Render the document
	pdf.render
	
	end
end
