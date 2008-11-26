class Site < ActiveRecord::Base
	belongs_to :school
	has_many :users
	
	validates_size_of	:name, :within => 1..20
end
