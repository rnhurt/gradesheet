class Enrollment < ActiveRecord::Base
	belongs_to :student
	belongs_to :course

	validates_existence_of	:course
	validates_existence_of	:student

	validates_uniqueness_of :student_id, :scope =>  :course_id


#	## Find all students enrolled in a particular course	
#	def self.find_students_by_course(*args)
#		find(:all, :conditions => {:course_id => args[0]} )
#	end	
	
end
