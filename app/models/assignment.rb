class Assignment < ActiveRecord::Base
	belongs_to	:course
	belongs_to	:assignmenttype
	has_many		:gradations
end
