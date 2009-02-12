class Gradation < ActiveRecord::Base
	belongs_to :student
	belongs_to :assignment

	validates_existence_of :student
	validates_existence_of :assignment


#	validates_uniqueness_of :student_id, :scope => [:assignment_id]
#	validates_uniqueness_of :assignment_id, :scope => [:student_id]

	validates_numericality_of	:points_earned, :allow_nil => :true, :greater_than_or_equal_to => 0.0
	
	validates_presence_of :flag, :unless => :valid_points?

	def valid_points?
		!self.points_earned.blank?
	end
	
end
