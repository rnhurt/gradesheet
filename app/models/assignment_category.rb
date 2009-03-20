class AssignmentCategory < ActiveRecord::Base
	has_many	:assignments
	
	validates_size_of        :name, :within => 1..20
  validates_uniqueness_of  :name, :case_sensitive => false

end
