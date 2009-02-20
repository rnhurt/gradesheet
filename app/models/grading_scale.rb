class GradingScale < ActiveRecord::Base
	has_many	:courses
	
	validates_presence_of	:name
	validates_length_of		:name, :within => 1..20

end
