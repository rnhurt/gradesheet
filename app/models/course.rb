class Course < ActiveRecord::Base
	has_many		:assignments
	has_many		:enrollments
	belongs_to	:terms
#	belongs_to :teacher
	
	validates_presence_of :teacher, :message => "%s wasn't found"
end
