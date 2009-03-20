class Student < User
	has_many		:enrollments
	has_many		:gradations
	has_many		:courses, 		:through	=> :enrollments
	has_many		:assignments,	:through	=> :gradations

	validates_length_of	:homeroom, :maximum => 20
	
	from_year = Time.now.year - 1
	to_year = from_year + 10
	validates_inclusion_of :class_of, 
	            :in => from_year..to_year, 
              :message => "must be in the range of #{from_year} to #{to_year}"
												
	named_scope	:courses, :joins => :courses

	def self.find_homerooms(*args)
		return Student.find(:all, :select => 'homeroom', :group => 'homeroom', :conditions => "homeroom > ''").map { |h| h.homeroom }
	end	
end
