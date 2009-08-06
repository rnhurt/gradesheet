# Contains the information about each course for each teacher.
class Course < ActiveRecord::Base
  before_destroy 	:ensure_no_children
  
  belongs_to	:teacher
  belongs_to  :school_year
  belongs_to  :grading_scale
  has_many		:enrollments
  has_many    :course_skills
  has_many    :course_terms
  has_many    :terms,                   :through => :course_terms
  has_many		:students,                :through => :enrollments
  has_many    :supporting_skills,       :through => :course_skills
  
  validates_existence_of :teacher, :message => "isn't a known teacher."
  validates_existence_of :grading_scale
  
  validates_length_of		:name, :in => 1..20
  # FIXME
  #	validates_uniqueness_of :teacher, :scope => [:term, :course]
  
  # Courses are considered 'active' only if they are in a grading term that is 'active'.
  named_scope :active, :include => :terms,
    :conditions	=> ["date_ranges.active = ?", true],
    :order => ["courses.name ASC"]
  
  # Calculate a students current grade for a particular course.
  def calculate_grade(student_id)
    # Set up some variables
    points_earned       = 0.0
    possible_points     = 0.0
    
    # Loop through the assignments for computing the grade as we go
    self.assignment_evaluations.all(:conditions => { :student_id => student_id}).each do |evaluation|
      points_earned += evaluation.points_earned.to_f
      possible_points += evaluation.assignment.possible_points.to_f
      puts " **** points earned: #{evaluation.points_earned} out of #{evaluation.assignment.possible_points}"
    end
    
    puts "  **** final! #{points_earned} out of #{possible_points} #{self.name}"
    # Sanitize the score & grade so that we don't try to divide by zero or anything stupid
    final_score = possible_points > 0 ? ((points_earned/possible_points)*100).round(2) : -1
    letter_grade = final_score > 0 ? self.grading_scale.calculate_letter_grade(final_score) : 'n/a'
    
    return {:letter => letter_grade, :score => final_score }
  end
  
  
  # Build a JavaScript function that converts a score to a letter grade based
  # on the grading scale of the course.
  def letterGradeCalc
    scale_ranges = ScaleRange.find_all_by_grading_scale_id(self.grading_scale_id, :order => 'max_score DESC')
    
    # Build the JavaScript function definition
    calcLetterGrade = "function calcLetterGrade(score) {"
    
    # Loop through the scale ranges building the JavaScript body
    scale_ranges.each do |scale_range|
      calcLetterGrade += " if(score >= #{scale_range.min_score}) {return '#{scale_range.letter_grade}';} else "
    end
    
    # Complete the JavaScript function
    calcLetterGrade +=  " return ''; }"
    
    return calcLetterGrade.to_json
  end
  
  
  private
  
  # Ensure that the user does not delete a record without first cleaning up
  # any records that use it.  This could cause a cascading effect, wiping out
  # more data than expected.	
  # FIXME
  def ensure_no_children
    #		unless self.assignments.empty?
    #			self.errors.add_to_base "You must remove all Assignments before deleting."
    #			raise ActiveRecord::Rollback
    #		end
  end
  
end
