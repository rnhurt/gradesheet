class SupportingSkill < ActiveRecord::Base
  belongs_to  :course_term
  has_many    :supporting_skill_evaluations

  validates_length_of :description, :within => 1..512
  validates_presence_of :supporting_skill_category

  named_scope :active, :conditions => { :active => true }
end
