class SupportingSkill < ActiveRecord::Base
  belongs_to  :supporting_skill_code
  belongs_to  :supporting_skill_category
  has_many    :course_term_skills
  has_many    :course_terms,  :through => :course_term_skills

  validates_length_of     :description, :within => 1..512
  validates_presence_of   :supporting_skill_category

  named_scope :active, :conditions => { :active => true }
end
