class Role < ActiveRecord::Base
	has_many :users
#	has_many :teachers
#	has_many :students
end
