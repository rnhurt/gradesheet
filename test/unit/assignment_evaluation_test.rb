require File.dirname(__FILE__) + '/../test_helper'

class AssignmentEvaluationTest < ActiveSupport::TestCase
	fixtures :all
	
	def setup
    @assignment_evaluation = AssignmentEvaluation.first
    assert @assignment_evaluation.valid?, "Initial assignment_evaluation is valid"
    @student = Student.first
    assert @student.valid?, "Initial student is valid"
	end
	def teardown
	end


	# Make sure that we only accept valid students & assignments
  def test_gradation_validates_presence_of
    @assignment_evaluation.student_id = -1
    assert !@assignment_evaluation.valid?, "Bad student_id"

    @assignment_evaluation.assignment_id = -1
    assert !@assignment_evaluation.valid?, "Bad assignment_id"
	end

	# Make sure we can not have invalid points_earned
  def test_gradation_points_earned_as_number
    @assignment_evaluation.points_earned = -1.4
    assert @assignment_evaluation.valid?, "set points_earned to an invalid float."
    assert_equal @assignment_evaluation.points_earned, 1.4, "points_earned converted to positive float"

    @assignment_evaluation.points_earned = 10.6
    assert @assignment_evaluation.valid?, "set points_earned to a valid float."
    assert_equal @assignment_evaluation.points_earned, 10.6, "points_earned converted to positive float"

    @assignment_evaluation.points_earned = -5
    assert @assignment_evaluation.valid?, "set points_earned to an invalid int."
    assert_equal @assignment_evaluation.points_earned, 5.0, "points_earned converted to positive float"

    @assignment_evaluation.points_earned = 16
    assert @assignment_evaluation.valid?, "set points_earned to a valid int."
    assert_equal @assignment_evaluation.points_earned, 16.0, "points_earned converted to positive float"
  end
  
  def test_gradation_points_earned_as_string
    @assignment_evaluation.points_earned = 'E'  # = 'E'xcused assignment
    assert @assignment_evaluation.valid?, "set points_earned to a valid upper case string."
    assert_equal @assignment_evaluation.points_earned, 'E', "points_earned converted to upper case string"

    @assignment_evaluation.points_earned = 'M'  # = 'M'issing assignment
    assert @assignment_evaluation.valid?, "set points_earned to a valid upper case string."
    assert_equal @assignment_evaluation.points_earned, 'M', "points_earned converted to upper case string"

    @assignment_evaluation.points_earned = 'm'  # = lower case
    assert @assignment_evaluation.valid?, "set points_earned to a valid lower case string."
    assert_equal @assignment_evaluation.points_earned, 'M', "points_earned converted to upper case string"

    @assignment_evaluation.points_earned = 'Q'  # = some invalid type
    assert !@assignment_evaluation.valid?, "set points_earned to an invalid string."

    @assignment_evaluation.points_earned = 'Moo'  # = some invalid type but starts with a good string
    assert !@assignment_evaluation.valid?, "set points_earned to an invalid string."

    @assignment_evaluation.points_earned = 'MM'
    assert !@assignment_evaluation.valid?, "set points_earned to an invalid string."

    @assignment_evaluation.points_earned = 'This is a really long string'
    assert !@assignment_evaluation.valid?, "set points_earned to a long string."
	end
	
	# Make sure that we can't have duplicates
  def test_gradation_duplicate_check
		gradation_copy = AssignmentEvaluation.new
		gradation_copy.student_id = @assignment_evaluation.student_id
		gradation_copy.assignment_id = @assignment_evaluation.assignment_id
		gradation_copy.points_earned = 666
		
		begin
      database_threw_error = false
      something_else_threw_error = false
  		gradation_copy.save
    rescue ActiveRecord::StatementInvalid
      database_threw_error = true
    rescue
      something_else_threw_error = true
    end

    assert !something_else_threw_error, "an unknown DB error occurred."
    assert database_threw_error && !something_else_threw_error, "error trying to save a duplicate record."
	end
end
