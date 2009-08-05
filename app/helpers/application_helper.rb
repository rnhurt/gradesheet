# This is the helper module for the entire application.  It should only contain
# methods that are used thoughout the system.
module ApplicationHelper

	# Generate the page title dynamically to reflect the current page information
	def title(new_title)
  	content_tag('h2', new_title, :class => 'page_title') if new_title
  end


	# Render the list of courses for the current user.  This method is called in
	# several locations throughout the system to let the user choose which Course
	# they want to work with.  It should only show "active" courses in "active"
	# grading terms.
	def show_course_list
		@courses = Course.active.find_all_by_teacher_id(current_user)
		render :partial => 'courses/course_list', :object => @courses
	end


	# Generate the MENU html for the current user from the [:authorize] parameter
	# of the session object.  This allows us to have a fairly flexible menu
	# while at the same time keeping maintenance to a minimum.
	def menu_builder(page_id)
    # Set a default menu for first time visitors.
    session[:authorize] ||= [['Home', 'dashboard']]
       
		content = ""
		session[:authorize].each do |t|
		  # Don't build a menu item without a name
		  next if t[0].size == 0
		  
			content << if page_id == t[1]
				# This is the current page, so give it a unique CSS class
				content_tag('li', content_tag('a', t[0], :href => "/#{t[1]}", :class => 'current' )) + " "
			else
				# This is not the current page.
				content_tag('li', content_tag('a', t[0], :href => "/#{t[1]}" )) + " "
			end
		end
		
		# Add in the spinner to the end of the menu
		content << 	"<div id='spinner' class='spinner' style='display: none;'><img src='/images/spinner.gif' alt=''></div>"

		# Close up the tags
		content_tag(:div, content_tag(:ul, content, :id => 'menu'), :class => 'menucontainer')
	end


	# Show the FLASH div if there is data in the flash object.
	def show_flash
		result = ''
		flash.each {|type, message| result << content_tag(:div, message, :id => 'notice', :class => type.to_s) } 
		return result
	end


	# Convenience method to set the focus to a specific element on the page
	def set_focus_to_id(id)
		javascript_tag("$('#{id}').focus()");
		javascript_tag("$('#{id}').select()");
	end


	# We need to know the range of years that should be available for our users to
	# choose from.  This application will be mainly used in schools that have
	# a limited number of class years.  So we give the user a total of 14 years
	# to work with; 1 before the current year, and 12 years after the current year.
	def class_range
		current_year = Time.now.year
		return (current_year - 1..current_year + 13).to_a
	end


	# This method was built to overcome a weakness in current_page? as reported
	# in http://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/805.
	# Here we are overriding the controller_name, mostly used on the 'Courses' page.
	def current_controller?(c)
		controller.controller_name == c
	end

  # Toggle the value of a checkbox between T and F using AJAX
  def toggle_value(object)
    remote_function(:url      => url_for(object),
                    :method   => :put,
                    :before   => "Element.show('spinner-#{object.id}')",
                    :complete => "Element.hide('spinner-#{object.id}')",
                    :with     => "this.name + '=' + this.checked")
  end
end
