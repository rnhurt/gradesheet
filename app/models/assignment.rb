class Assignment < ActiveRecord::Base
	belongs_to	:course
	belongs_to	:assignment_type
	has_many		:gradations
	
	validates_existence_of	:course
	validates_presence_of		:possible_points
end
