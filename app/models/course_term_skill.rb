# Links the course_term with supporting skills.
class CourseTermSkill < ActiveRecord::Base
  belongs_to  :course_term
  belongs_to  :supporting_skill
end
