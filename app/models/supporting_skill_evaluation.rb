class SupportingSkillEvaluation < ActiveRecord::Base
  belongs_to :user
  belongs_to :supporting_skill_code
  belongs_to :supporting_skill
end
