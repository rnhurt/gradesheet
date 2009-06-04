# Contains the details about each assignment.
class Assignment < ActiveRecord::Base
  before_destroy :ensure_no_children
  
  belongs_to	:course
  belongs_to	:assignment_category
  has_many		:assignment_evaluations
  
  validates_length_of				:name, :within => 1..20
  validates_numericality_of	:possible_points
  validates_presence_of			:possible_points
  
  validates_existence_of		:course

  # Return a date formated for display as an assignment due date.
  def due_date_formated
  	due_date.strftime("%a %b %e, %Y") if due_date?
  end
  
  # Return a date
  def due_date_formated=(due_at_str)
    # Is this still needed?
    self.due_date = Date.parse(due_at_str) if due_date?
  rescue ArgumentError
  	@due_date_invalid = true
  end
  
  # Validate assignment due dates
  def validate
    # Is this still needed?
  	errors.add(:due_date, "is invalid") if @due_date_invalid
  end
  
  
private
  
  # We don't want the user to delete an assignment without first cleaning up
  # any grades that use it.  This could cause a cascading effect wiping out
  # a whole year of student data.	
  def ensure_no_children
  	unless self.assignment_evaluations.empty?
  		self.errors.add_to_base "You must remove all assignment evaluations before deleting."
  		raise ActiveRecord::Rollback
  	end
  end
  
end
