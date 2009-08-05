class SupportingSkill < ActiveRecord::Base
  has_many    :supporting_skill_evaluations
  belongs_to  :supporting_skill_category
  belongs_to  :course_term

  has_many    :course_skills
  has_many    :supporting_skills, :through => :course_skills

  validates_length_of :description, :within => 1..512
  validates_presence_of :supporting_skill_category

  named_scope :active, :conditions => { :active => true }
end
