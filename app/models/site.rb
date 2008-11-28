class Site < ActiveRecord::Base
	belongs_to :school
	has_many :users
	
	validates_presence_of	:name
	validates_size_of			:name, :within => 1..20
end
