class SupportingSkill < ActiveRecord::Base
  has_many    :supporting_skill_evaluations
  belongs_to  :supporting_skill_category
  belongs_to  :course

  validates_length_of :description, :within => 1..512

  named_scope :active, :conditions => { :active => true }
end
