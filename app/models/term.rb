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
		
		
	# Make sure that the BEGIN date is earlier than the END date
	def begin_before_end
		errors.add_to_base("End Date must be after the Begin Date") if begin_date >= end_date
	end
	
	# Delete the term from the database
	def delete=(params)
		if courses.empty?
	    @term = Term.find(self[:id])
  	  @term.destroy
		else
			errors.add_to_base "Cannot delete term because it has one or more Courses"
			return false
		end
	end
	
	
end
