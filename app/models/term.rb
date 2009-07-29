# Contains the details on the grading periods and several date standardizations.
class Term < DateRange
	before_destroy	:ensure_no_children
	
	has_many    :courses
  belongs_to  :school_year
#	has_many :comments

	validates_length_of		:name, :within => 1..20
	validates_length_of		:school_year, :within => 1..20	

	# This model is pretty heavily dependant upon dates and make sure that they
	# are correct.  So, we need to do some checking to make sure everything
	# is in order before we save any data.
	validate do |dates|
		dates.begin_before_end
		# dates.period_overlap
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
	
	# Make sure that no period date overlap another period
	def period_overlap
		# TODO: 
		#errors.add_to_base("Period dates cannot overlap another period") if <some magic>
	end	


private   

  # Ensure that the user does not delete a record without first cleaning up
  # any records that use it.  This could cause a cascading effect, wiping out
  # more data than expected.	
	def ensure_no_children
		unless self.courses.empty?
			self.errors.add_to_base "You must remove all Courses before deleting."
			raise ActiveRecord::Rollback
		end
	end

end
