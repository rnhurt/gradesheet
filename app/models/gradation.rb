class Gradation < ActiveRecord::Base
	belongs_to :assignment
	belongs_to :student
	
	validates_presence_of :assignment	
end
