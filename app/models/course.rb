class Course < ActiveRecord::Base
	belongs_to	:teacher
	belongs_to	:term
	belongs_to	:course_type
	belongs_to	:grading_scale
	has_many		:assignments
	has_many		:enrollments
	
	validates_presence_of :teacher, :message => "%s wasn't found"
end
