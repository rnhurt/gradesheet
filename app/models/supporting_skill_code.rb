class SupportingSkillCode < ActiveRecord::Base
#	before_destroy	:ensure_no_children
#  after_update  :save_ranges

  has_many    :supporting_skills

	validates_length_of		  :description, :within => 1..50
	validates_uniqueness_of :description, :case_sensitive => false

  named_scope :active, :conditions => { :active => true }

  def self.valid_codes
    self.all(:select => 'code', :group => 'code', :conditions => "code > ''").map { |i| i.code }
  end

end
