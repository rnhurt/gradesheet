# Contains the information about the User archtype.  This class is not used
# directly but subclassed for other user types (Teacher, Student, etc.) 
class User < ActiveRecord::Base
  # Authlogic setup
  acts_as_authentic do |c|
    # Set the timeout to something workable while in development
    c.logged_in_timeout = (RAILS_ENV == 'development' ? 1000.minutes : 10.minutes)
    
    # Turn off the email validation as some students/teachers might not have an address.
    c.validate_email_field = false
  end
  
  belongs_to	:site
  #	has_many		:comments

	validates_length_of			:first_name, :in => 1..20
	validates_length_of			:last_name, :in => 1..20
	validates_existence_of 	:site

  named_scope :active, :conditions => { :active => true }

	# Search for a user using the 'will_paginate' plugin
	def self.search(params)
    search = params[:search]
		search.downcase! if search	# Make sure we don't have any case sensitivity problems
		paginate	:per_page => 15, :page => params[:page],
      :conditions => ['LOWER(first_name) like ? or LOWER(last_name) like ?', "%#{search}%", "%#{search}%"],
      :order => params[:sort_clause],
      :include => :site
	end
	
	# Return the valid user types available
	def self.user_types
    types = []
    types << {'All (active)' => nil} << {'Students' => Student}
    types << {'Teachers' => Teacher} << {'Teacher Assistants' => TeacherAssistant}
	end

	# Display the user's full name.
	def full_name
		[first_name, last_name].join(' ')
	end
	
	# Break a user's full name into its components
	def full_name=(name)
		split = name.split(' ', 2)
		self.first_name = split.first
		self.last_name = split.last
	end

end
