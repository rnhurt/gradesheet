class QuickComment < ActiveRecord::Base
	validates_size_of        :description, :within => 1..200

  named_scope :active, :conditions => { :active => true }

end
