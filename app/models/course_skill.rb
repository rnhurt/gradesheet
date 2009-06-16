class CourseSkill < ActiveRecord::Base
  belongs_to  :course
  belongs_to  :supporting_skill
end
