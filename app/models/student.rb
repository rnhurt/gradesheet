# Subclass of User that handles the Student users
class Student < User  
	has_many		:enrollments
  has_many		:courses,             :through => :enrollments
	has_many		:assignment_evaluations
	has_many		:assignments,         :through => :assignment_evaluations
  has_many    :supporting_skill_evaluations
  has_many    :course_term_skills,  :through => :supporting_skill_evaluations

  has_one     :comment, :as => :commentable

	validates_length_of	:homeroom, :maximum => 20
	
	from_year = Time.now.year - 1
	to_year = from_year + 10
	validates_inclusion_of :class_of, 
    :in => from_year..to_year,
    :message => "must be in the range of #{from_year} to #{to_year}"

  named_scope :homerooms, :select => 'DISTINCT homeroom name', :conditions => {:active => true}
  named_scope :sorted, :order => 'last_name ASC'

  def current_course_terms
    return CourseTerm.all(:joins => :course)
  end

  def self.find_classes_of
    return Student.all(
      :select     => "class_of",
      :group      => "class_of",
      :conditions => "class_of is not null",
      :order      => "class_of"
      )
  end
end
