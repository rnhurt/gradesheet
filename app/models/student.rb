# Subclass of User that handles the Student users
class Student < User
	has_many		:enrollments
	has_many		:assignment_evaluations
	has_many		:courses, 		:through	=> :enrollments
	has_many		:assignments,	:through	=> :assignment_evaluations

	validates_length_of	:homeroom, :maximum => 20
	
	from_year = Time.now.year - 1
	to_year = from_year + 10
	validates_inclusion_of :class_of, 
	            :in => from_year..to_year, 
              :message => "must be in the range of #{from_year} to #{to_year}"

	named_scope	:courses, :joins => :courses


  # Return an array of unique homerooms that are in the system.
	def self.find_homerooms(*args)
    # FIXME: This should probably just return homerooms that are being used by 'valid' students
		return Student.all(:select => 'homeroom', :group => 'homeroom', 
		        :conditions => "homeroom > ''").map { |h| h.homeroom }
	end
end
