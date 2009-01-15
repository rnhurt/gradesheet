class Student < User
	has_many	:enrollments
	has_many	:courses, :through => :enrollments

	validates_length_of	:homeroom, :maximum => 20
	
	from_year = Time.now.year - 1
	to_year = from_year + 10
	validates_inclusion_of :class_of, :in => from_year..to_year, 
												:message => "must be in the range of #{from_year} to #{to_year}"
												
#	named_scope	:course_id, :joins => :enrollments, :conditions => { :id => :student_id }

	# FIXME
	named_scope	:courses, :joins => :courses
	

end
