class SupportingSkillCategory < ActiveRecord::Base
  has_many    :supporting_skills

  validates_length_of :name, :within => 1..50

  named_scope :active, :conditions => { :active => true }
end
