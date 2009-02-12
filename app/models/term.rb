class Term < ActiveRecord::Base
	has_many :courses
#	has_many :comments

	validates_presence_of	:name
	validates_length_of		:name, :within => 1..20	


	def self.find_active()
		# Find all terms that are currently active
		find(:all, { :conditions => { :active => true } })
	end

	def self.find_current()
		# Find the current term
		find(:all, :conditions => ["? BETWEEN begin_date and end_date ", Date.today])
	end
	
end
