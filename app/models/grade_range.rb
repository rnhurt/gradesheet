# Contains the minimum & maximum grades possible and their letter scores.
class GradeRange < ActiveRecord::Base
  belongs_to  :grading_scale

  attr_accessor :should_destroy

  # This attribute is set in the grade_range partial when the user wants to 
  # remove an existing grade range.
  def should_destroy?
    should_destroy.to_i == 1
  end

end
