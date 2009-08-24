# Contains the details on the grading periods and several date standardizations.
class Term < DateRange
  before_destroy	:ensure_no_children

  belongs_to  :school_year
  has_many    :course_terms
  has_many    :courses,     :through => :course_terms
  #	has_many :comments

  validates_length_of		:name, :within => 1..20
  validates_date        :begin_date, :before => :end_date
  validates_date        :end_date, :after => :begin_date

  # Grading Terms are set as active or inactive by the school administrator.
  # Editing activities (entering grades, changing courses, etc.) are limited to
  # "active" terms.  Once a term is set as inactive Teachers cannot change
  # anything in that term.
  named_scope :active, :conditions => { :active => true }

  # The current Grading Term is used as a default value in a lot of places.  Creating
  # a new Course, running a report, etc. all show the user the current term.
  named_scope :current, lambda { || { :conditions => ["? BETWEEN begin_date and end_date ", Date.today] } }

  private

  # Ensure that the user does not delete a record without first cleaning up
  # any records that use it.  This could cause a cascading effect, wiping out
  # more data than expected.
  def ensure_no_children
    unless self.courses.empty?
      self.errors.add_to_base "You must remove all Courses before deleting."
      raise ActiveRecord::Rollback
    end
  end

end
