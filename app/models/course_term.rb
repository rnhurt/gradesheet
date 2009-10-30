# Links the course with each of its terms or grading periods.
class CourseTerm < ActiveRecord::Base
	belongs_to  :term
	belongs_to  :course
  has_many    :course_term_skills
  has_many    :supporting_skills,       :through => :course_term_skills
  has_many    :assignments
	has_many    :assignment_evaluations,  :through => :assignments
  
	validates_existence_of	:term
	validates_existence_of	:course
	validates_uniqueness_of :course_id, :scope =>  :term_id

  delegate :school_year,    :to => :term
  delegate :active,         :to => :term
  delegate :grading_scale,  :to => :course
  delegate :students,       :to => :course

  # Calculate a students current grade for a particular course & term.
  def calculate_grade(student_id)
    # Set up some variables
    points_earned       = 0.0
    possible_points     = 0.0

    # Loop through the assignments for computing the grade as we go
    self.assignment_evaluations.all(:conditions => { :student_id => student_id}).each do |evaluation|
      valid_points = evaluation.points_earned_as_number
      if valid_points
        points_earned += valid_points.to_f
        possible_points += evaluation.assignment.possible_points.to_f
      end
      logger.debug " **** points earned: #{valid_points} out of #{evaluation.assignment.possible_points}"
    end

    logger.debug  " **** final! #{points_earned} out of #{possible_points}"
    # Sanitize the score & grade so that we don't try to divide by zero or anything stupid
    final_score = possible_points > 0 ? ((points_earned/possible_points)*100).round(2) : -1
    letter_grade = final_score > 0 ? self.course.grading_scale.calculate_letter_grade(final_score) : 'n/a'

    return {:letter => letter_grade, :score => final_score }
  end

end
