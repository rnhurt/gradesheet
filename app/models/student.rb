class Student < User
	has_many	:enrollments
	has_many	:courses, :through => :enrollments
	
	from_year = Time.now.year - 1
	to_year = from_year + 10
	validates_inclusion_of :class_of, :in => from_year..to_year, 
												:message => "must be in the range of #{from_year} to #{to_year}"
												
#	named_scope	:course_id, :joins => :enrollments, :conditions => { :id => :student_id }

	named_scope	:courses, :joins => :courses
	
#	## Find all students enrolled in a particular course	
#	def self.find_by_course(*args)
#		with_scope :find => { :conditions => { :course_id => args[0] } } do
#			find(*args)
#		end
#	end	

end
