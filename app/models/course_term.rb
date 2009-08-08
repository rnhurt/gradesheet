# Links the course with each of its terms or grading periods.
class CourseTerm < ActiveRecord::Base
	belongs_to :term
	belongs_to :course

  has_many  :assignments
  has_many  :supporting_skills
	has_many  :assignment_evaluations,        :through => :assignments
  has_many  :supporting_skills_evaluations, :through => :supporting_skills

	validates_existence_of	:term
	validates_existence_of	:course

	validates_uniqueness_of :course_id, :scope =>  :term_id

end
