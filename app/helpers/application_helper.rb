# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	## Generate the page title
	def title(new_title)
  	content_tag('h2', new_title, :class => 'page_title') if new_title
  end

	## Generate the MENU html
	def menu_builder(page_id)
		tabs = [ 'Home:dashboard', 'People:users', 'Courses:courses', 
						'Assignments:assignments', 'Enrollments:enrollments' ]

		content = ""
		tabs.each do |tab|
			t = tab.split(':')
			content << if page_id == t[1]
				content_tag('li', content_tag('a', t[0], :href => nil, :class => 'current' )) + " "
			else
				content_tag('li', content_tag('a', t[0], :href => "/#{t[1]}" )) + " "
			end
		end
		
		## Add in the spinner to the end of the list
#		content << 	'<div id="busy" class="spinner"><img src="/images/spinner.gif" alt=""></div>'

		## Close up the tags
		content_tag(:div, content_tag(:ul, content, :id => 'menu'), :class => 'menucontainer')
	end


	## Show the FLASH div
	def show_flash
		result = ''
		flash.each {|type, message| result << content_tag(:div, message, :class => "flash " + type.to_s) } 
		return result
	end


	## Set the focus to a specific element on the page
	def set_focus_to_id(id)
		javascript_tag("$('#{id}').focus()");
		javascript_tag("$('#{id}').select()");
	end


	## Return the valid class_of date range
	def class_range
		current_year = Time.now.year
		return (current_year - 1..current_year + 13).to_a
	end


end
