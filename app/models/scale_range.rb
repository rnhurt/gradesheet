# Contains the minimum & maximum grades possible and their letter scores.
class ScaleRange < ActiveRecord::Base
  belongs_to  :grading_scale

  validates_length_of       :description, :within => 0..250
  validates_length_of       :letter_grade, :within => 1..20

  validates_numericality_of :max_score, :greater_than_or_equal_to => 0
  validates_numericality_of :min_score, :greater_than_or_equal_to => 0

  attr_accessor :should_destroy

  def before_validation
    if min_score >= max_score
      self.errors.add_to_base("Minimum Score cannot be greater than Maximum Score")
      return false 
    end

  end

  # This attribute is set in the scale_range partial when the user wants to 
  # remove an existing grade range.
  def should_destroy?
    should_destroy.to_i == 1
  end

end
