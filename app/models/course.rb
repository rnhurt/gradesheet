# Contains the information about each course for each teacher.
class Course < ActiveRecord::Base
	before_destroy 	:ensure_no_children

	belongs_to	:teacher
	belongs_to	:term
	belongs_to	:grading_scale
	has_many		:assignments
	has_many		:enrollments
	has_many		:students, :through => :enrollments
	has_many		:assignment_evaluations, :through => :assignments
  has_many    :course_skills
  has_many    :supporting_skills, :through => :course_skills
	
	validates_existence_of :teacher, :message => "isn't a known teacher."
	validates_existence_of :term
	validates_existence_of :grading_scale
	
	validates_length_of		:name, :in => 1..20
	# FIXME
	#	validates_uniqueness_of :teacher, :scope => [:term, :course]

	# Courses are considered 'active' only if they are in a grading term that is 'active'.
	named_scope :active, :include => :term, :conditions	=> "terms.active = 't'"


  # Calculate a students current grade for a particular course.
  def calculate_grade(student_id)
    # Get the student record
    student = Student.find(student_id)
    
    # Set up some variables
    final_grade         = 0.0
    temp_score          = 0.0
    total_avail_points  = 0.0

    # Loop through the assignments for computing the grade as we go
    
    
    
    return {:letter => 'A', :score => 0.78}
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
	def ensure_no_children
		unless self.assignments.empty?
			self.errors.add_to_base "You must remove all Assignments before deleting."
			raise ActiveRecord::Rollback
		end
	end

end
