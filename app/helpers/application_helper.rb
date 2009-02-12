# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	## Generate the page title
	def title(new_title)
  	content_tag('h2', new_title, :class => 'page_title') if new_title
  end


	## FIXME - Get the current user.  This will probably change when we add real auth capabilities
	def current_user
		session[:user_id] ? @current_user ||= User.find(session[:user_id]) : nil
	end


	## Render the list of courses for the current user.
	def show_course_list
		@courses = Course.find_all_by_teacher_id(current_user, :include => [:term])
		render :partial => 'courses/course_list', :object => @courses
	end


	## Generate the MENU html
	def menu_builder(page_id)
		tabs = [ 'Home:dashboard', 'Users:users', 'Courses:courses', 
						'Assignments:assignments', 'Grades:gradations', 'Reports:reports', 'My Settings:settings' ]

		content = ""
		tabs.each do |tab|
			t = tab.split(':')
			content << if page_id == t[1]
				## This is the current page, so give it a unique CSS class
				content_tag('li', content_tag('a', t[0], :href => "/#{t[1]}", :class => 'current' )) + " "
			else
				## This is not the current page.
				content_tag('li', content_tag('a', t[0], :href => "/#{t[1]}" )) + " "
			end
		end
		
		## Add in the spinner to the end of the menu
		content << 	"<div id='spinner' class='spinner' style='display: none;'><img src='/images/spinner.gif' alt=''></div>"

		## Close up the tags
		content_tag(:div, content_tag(:ul, content, :id => 'menu'), :class => 'menucontainer')
	end


	## Show the FLASH div
	def show_flash
		result = ''
		flash.each {|type, message| result << content_tag(:span, message, :id => 'notice', :class => type.to_s) } 
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
