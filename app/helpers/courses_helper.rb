module CoursesHelper
	## This method was built to overcome a weakness in current_page? as reported
	## in http://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/805
	def current_controller?(c)
		controller.controller_name == c
	end
end
