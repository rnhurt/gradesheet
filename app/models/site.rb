class Site < ActiveRecord::Base
  before_destroy  :ensure_no_children

	belongs_to :school
	has_many :users
	
	validates_size_of        :name, :within => 1..20
  validates_uniqueness_of  :name, :case_sensitive => false
  
##
# Private Methods
##
	def ensure_no_children
	  ## TODO: Not really sure what should go here
		unless self.users.empty?
			self.errors.add_to_base "Cannot delete campus while users are still registered to it."
			raise ActiveRecord::Rollback
		end
	end

end
