class SupportingSkill < ActiveRecord::Base
  has_many    :supporting_skill_evaluations
  belongs_to  :course
end
