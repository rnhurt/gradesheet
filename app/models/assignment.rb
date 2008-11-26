class Assignment < ActiveRecord::Base
	belongs_to	:course
	belongs_to	:assignment_type
	has_many		:gradations
	
	validates_presence_of			:name
	validates_numericality_of	:possible_points
	validates_presence_of			:possible_points
	
	validates_existence_of	:course
	
	def due_date_formated
		due_date.strftime("%a %b %e, %Y") if due_date?
	end
	
	def due_date_formated=(due_at_str)
		self.due_date = Date.parse(due_at_str)
	rescue ArgumentError
		@due_date_invalid = true
	end
	
	def validate
		errors.add(:due_date, "is invalid") if @due_date_invalid
	end
end
