class Term < ActiveRecord::Base
	has_many :courses
#	has_many :comments

	validates_presence_of	:name
	validates_length_of		:name, :within => 1..20	

	# Grading Terms are set as active or inactive by the school administrator.
	# Editing activities (entering grades, changing courses, etc.) are limited to 
	# "active" terms.  Once a term is set as inactive Teachers cannot change 
	# anything in that term.  
	named_scope :active, :conditions => { :active => true }
	
	# The current Grading Term is used as a default value in a lot of places.  Creating
	# a new Course, running a report, etc. all show the user the current term.
	named_scope	:current, :conditions => ["? BETWEEN begin_date and end_date ", Date.today]
		
end
