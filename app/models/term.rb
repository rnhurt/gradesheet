class Term < ActiveRecord::Base
	has_many :courses
#	has_many :comments

	validates_presence_of	:name
	validates_length_of		:name, :within => 1..20	


	def self.find_active(*args)
		## Find all terms that are currently active
		with_scope :find => { :conditions => { :active => true } } do
			find(*args)
		end
	end

	def self.find_current(*args)
		## Find the current term
		with_scope :find => { :conditions => { Date.today => :begin_date .. :end_date } } do
			find(*args)
		end
	end
	
	
end
