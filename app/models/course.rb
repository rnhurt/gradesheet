# Contains the information about each course for each teacher.
class Course < ActiveRecord::Base
  before_destroy 	:ensure_no_children
  
  belongs_to	:teacher
  belongs_to  :grading_scale
  
  has_many		:enrollments
  has_many    :course_terms
  has_many    :terms,     :through => :course_terms
  has_many		:students,  :through => :enrollments

  validates_existence_of :teacher, :message => "isn't a known teacher."
  validates_existence_of :grading_scale
  
  validates_length_of		:name, :in => 1..20
  # FIXME
  #	validates_uniqueness_of :teacher, :scope => [:term, :course]
  
  # Courses are considered 'active' only if they are in a grading term that is 'active'.
  named_scope :active, :include => :terms,
    :conditions	=> ["date_ranges.active = ?", true],
    :order => ["courses.name ASC"]

  # Find all the courses for a particular school year
  named_scope :by_school_year, lambda { |*school_year| 
    { :include => :terms,
      :conditions => ["date_ranges.school_year_id = ?", school_year ||= SchoolYear.current_year]
    }
  }
  
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
