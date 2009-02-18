class Term < ActiveRecord::Base
	has_many :courses
#	has_many :comments

	validates_presence_of	:name
	validates_length_of		:name, :within => 1..20	

	validates_presence_of	:school_year
	validates_length_of		:school_year, :within => 1..20	

	# This model is pretty heavily dependant upon dates and make sure that they
	# are correct.  So, we need to do some checking to make sure everything
	# is in order before we save any data.
	validate do |dates|
		dates.begin_before_end
	end


	# Grading Terms are set as active or inactive by the school administrator.
	# Editing activities (entering grades, changing courses, etc.) are limited to 
	# "active" terms.  Once a term is set as inactive Teachers cannot change 
	# anything in that term.  
	named_scope :active, :conditions => { :active => true }
	
	# The current Grading Term is used as a default value in a lot of places.  Creating
	# a new Course, running a report, etc. all show the user the current term.
	named_scope	:current, :conditions => ["? BETWEEN begin_date and end_date ", Date.today]
		
		
	def begin_before_end
#		errors.add_to_base("End Date must be after the Begin Date") # unless false
		errors.add("begin_date", "must be before the End Date")
	end


   def self.update_terms(terms)
		terms.each do |term_id, attributes|
			term = find(term_id.to_i)
			return false if !term.update_attributes(attributes)
     end
   end	
end
