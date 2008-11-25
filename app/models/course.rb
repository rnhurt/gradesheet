class Course < ActiveRecord::Base
	belongs_to	:teacher
	belongs_to	:term
	belongs_to	:course_type
	belongs_to	:grading_scale
	has_many		:assignments
	has_many		:enrollments
	
	validates_existence_of :teacher, :message => "%s wasn't found"
	validates_existence_of :term
	validates_existence_of :course_type
	validates_existence_of :grading_scale
	
	validates_presence_of :name
end
