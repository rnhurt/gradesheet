# Links the course_term with supporting skills.
class CourseTermSkill < ActiveRecord::Base
  belongs_to  :course_term
  belongs_to  :supporting_skill
  has_many    :supporting_skill_evaluations

  validates_associated    :course_term, :supporting_skill
  validates_uniqueness_of :course_term_id, :scope => :supporting_skill_id

  # Calculate a students current score for a particular course & term.
  def score(student_id)
    temp = self.supporting_skill_evaluations.detect{|e| e.student_id == student_id}
    return temp.blank? ? "" : temp.score
  end

end
