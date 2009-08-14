# Links the course_term with supporting skills.
class CourseTermSkill < ActiveRecord::Base
  belongs_to  :course_term
  belongs_to  :supporting_skill
  has_many    :supporting_skill_evaluations

  # Calculate a students current score for a particular course & term.
  def score(student_id)
    temp = self.supporting_skill_evaluations.first(:conditions => { :student_id => student_id})
    return temp.blank? ? "" : temp.score
  end

end
