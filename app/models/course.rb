# Contains the information about each course for each teacher.
class Course < ActiveRecord::Base
	before_destroy 	:ensure_no_children

	belongs_to	:teacher
	belongs_to	:term
	belongs_to	:grading_scale
	has_many		:assignments
	has_many		:enrollments
	has_many		:students, :through => :enrollments
	has_many		:gradations, :through => :assignments
	
	validates_existence_of :teacher, :message => "isn't a known teacher."
	validates_existence_of :term
	validates_existence_of :grading_scale
	
	validates_length_of		:name, :in => 1..20
	# FIXME
	#	validates_uniqueness_of :teacher, :scope => [:term, :course]

	# Courses are considered "active" only if they are in a grading term that is "active".
	named_scope :active, :include => :term, :conditions	=> "terms.active = 't'"


private		

  # Ensure that the user does not delete a record without first cleaning up
  # any records that use it.  This could cause a cascading effect, wiping out
  # more data than expected.	
	def ensure_no_children
		unless self.assignments.empty?
			self.errors.add_to_base "You must remove all Assignments before deleting."
			raise ActiveRecord::Rollback
		end
	end

end
