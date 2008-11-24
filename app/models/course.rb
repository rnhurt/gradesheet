class Course < ActiveRecord::Base
	has_many		:assignments
	has_many		:enrollments
	belongs_to	:teacher
	belongs_to	:term
	
	validates_presence_of :teacher, :message => "%s wasn't found"
end
