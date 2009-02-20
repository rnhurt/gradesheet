class GradingScale < ActiveRecord::Base
	before_destroy	:ensure_no_children

	has_many	:courses
	
	validates_presence_of	:name
	validates_length_of		:name, :within => 1..20


##
# Private Methods
##
private		


	# We don't want the user to delete a grading scale without first cleaning up
	# any courses that use it.
	def ensure_no_children
		unless self.courses.empty?
			self.errors.add_to_base "You must remove all Courses before deleting."
			raise ActiveRecord::Rollback
		end
	end

end
