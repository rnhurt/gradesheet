class SampleReport
	def self.draw()


poem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer purus lorem, eleifend nec, venenatis quis, congue nec, eros. Etiam odio erat, aliquam aliquam, ultricies non, interdum vehicula, ligula. Proin ut dolor vel massa interdum vulputate. Praesent ac est. Duis justo tellus, fringilla sed, suscipit id, vulputate vitae, urna. Curabitur lobortis bibendum massa. Integer tellus justo, viverra et, pulvinar ac, tempor sit amet, orci. Fusce a lacus. Etiam consectetur, lorem ac sollicitudin pharetra, mauris turpis adipiscing ante, ut faucibus dui lorem luctus erat. Sed quis justo ac tortor condimentum tincidunt. Cras ut mi at urna elementum luctus. Vivamus vel orci ac enim ultrices ullamcorper. Quisque lacinia tincidunt ipsum. Nullam ac libero et pede volutpat pretium. Nunc vulputate tristique massa. Vivamus venenatis ullamcorper arcu. Donec tincidunt, urna ac ultrices condimentum, lorem magna dignissim tellus, ac tempor lacus enim nec ligula. Sed non libero id nulla lobortis lacinia. "

		# Create a new document
	  pdf = Prawn::Document.new 

#		pdf.image open("http://desktop:3000/images/logo.png")

#		pdf.header pdf.margin_box.top_left do 
#		  pdf.font "Courier" do
#		  	pdf.fill_color "555555"
#		    pdf.text "Report Card", :size => 25, :align => :center
#		    pdf.stroke_horizontal_rule
#		  end
#		end   
		
#	  pdf.font "#{Prawn::BASEDIR}/data/fonts/Chalkboard.ttf"
#	  pdf.text "The rain in Spain falls mainly in the plains. " * 10

		pdf.start_new_page
		
		pdf.font "Times-Roman"
		pdf.stroke_line [pdf.bounds.left,  pdf.bounds.top],
		                [pdf.bounds.right, pdf.bounds.top]
		pdf.text "This is some content that we need to see", :size => 10

		pdf.bounding_box([100,600], :width => 200, :height => 500) do
		  pdf.stroke_line [pdf.bounds.left,  pdf.bounds.top],
		                  [pdf.bounds.right, pdf.bounds.top]
		  pdf.text poem, :size => 12
		end

		pdf.bounding_box([325,600], :width => 200, :height => 500) do
		  pdf.stroke_line [pdf.bounds.left,  pdf.bounds.top],
		                  [pdf.bounds.right, pdf.bounds.top]
		  pdf.text poem.reverse, :size => 12
		end
		pdf.text "and here is the overflow text" * 10, :size => 14
		pdf.text "Hooray! We've conquered the evil PDF gods", :size => 36

#		# Set up the look & feel
#		pdf.font "Helvetica" 


#		# Generate content
#		pdf.text 'Hello World from sample_report.rb!', :size => 35, :style => :bold, :spacing => 4

##		pdf.move_to [100,100]
##		pdf.text 'Test Circle'
##		pdf.circle_at [100,100], :radius => 25

##		pdf.text 'Test Horizontal Line'	
##		pdf.horizontal_line(10, 100)
##		
		pdf.start_new_page
		
		pdf.move_to [100,100]
		pdf.stroke_curve_to [50,50], :bounds => [[20,90], [90,90]]  
		pdf.fill_circle_at [200,200], :radius => 10

	  pdf.fill_color 50, 100, 0, 0
		pdf.text "Prawn is CYMK Friendly"

		pdf.start_new_page

		pdf.fill_color "ff0000"
		pdf.fill_polygon [100, 250], [200, 300], [300, 250],
				             [300, 150], [200, 100], [100, 150] 

		# Render the document
		pdf.render
	end
end
