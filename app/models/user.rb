class User < ActiveRecord::Base
	belongs_to	:site
	has_many		:courses, :through => :enrollment
	has_many		:gradations
#	has_many		:comments
	
	validates_presence_of :first_name, :message => " is required"
	validates_presence_of :last_name, :message => " is required"
#	validates_existence_of :site
	
end
