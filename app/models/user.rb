class User < ActiveRecord::Base
	belongs_to	:site
	has_many		:courses, :through => :enrollment
	has_many		:gradations
#	has_many		:comments
	
	validates_presence_of :first_name, :message => " is required"
	validates_presence_of :last_name, :message => " is required"
	validates_existence_of :site

	## Search for a user (will_paginate)
	def self.search(search, page)
		paginate :per_page => 10, :page => page,
							:conditions => ['first_name like ? or last_name like ?', "%#{search}%", "%#{search}%"], 
							:order => 'first_name'
	end
		
	## Display the users full name
	def full_name
		[first_name, last_name].join(' ')
	end
	
	## Break a full name into first_name & last_name
	def full_name=(name)
		split = name.split(' ', 2)
		self.first_name = split.first
		self.last_name = split.last
	end

end
