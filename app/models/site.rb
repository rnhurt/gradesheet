class Site < ActiveRecord::Base
  before_destroy  :ensure_no_children

	belongs_to :school
	has_many :users
	
	validates_size_of        :name, :within => 1..20
  validates_uniqueness_of  :name, :case_sensitive => false
  
private

  # Ensure that the user does not delete a record without first cleaning up
  # any records that use it.  This could cause a cascading effect, wiping out
  # more data than expected.	
	def ensure_no_children
		unless self.users.empty?
			self.errors.add_to_base "Cannot delete campus while users are still registered to it."
			raise ActiveRecord::Rollback
		end
	end

end
