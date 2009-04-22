# Contains the grading scale data used for each course.
class GradingScale < ActiveRecord::Base
	before_destroy	:ensure_no_children

	has_many	:courses
	
	validates_length_of		  :name, :within => 1..20
	validates_uniqueness_of :name, :case_sensitive => false


private		
  # Ensure that the user does not delete a record without first cleaning up
  # any records that use it.  This could cause a cascading effect, wiping out
  # more data than expected.	
	def ensure_no_children
		unless self.courses.empty?
			self.errors.add_to_base "You must remove all Courses before deleting."
			raise ActiveRecord::Rollback
		end
	end

end
