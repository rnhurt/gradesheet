class Course < ActiveRecord::Base
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


	# FIXME
	named_scope	:students, :joins => :students, :conditions => { :course_id => 666 }

	# Find all the courses for a given student
	def self.find_yomama(student_id)
		find_by_sql ["select * from users, gradations, assignments, courses where users.id = ? and users.id = gradations.student_id and assignments.id = gradations.assignment_id and courses.id = assignments.course_id;", student_id ]
	end
	
end
