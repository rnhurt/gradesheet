require File.dirname(__FILE__) + '/../test_helper'

class GradationTest < ActiveSupport::TestCase
	fixtures :assignments, :users
	
	def setup
    @gradation = Gradation.first
    @student = Student.first
	end
	def teardown
	end


	# Make sure that we only accept valid students & assignments
  def test_gradation_validates_presence_of
    @gradation.student_id = -1
    assert !@gradation.valid?, "Bad student_id"

    @gradation.assignment_id = -1
    assert !@gradation.valid?, "Bad assignment_id"
	end

	# Make sure we can not have invalid points_earned
  def test_gradation_points_earned_as_number
    @gradation.points_earned = -1.4
    assert !@gradation.valid?, "set points_earned to an invalid float."

    @gradation.points_earned = 1.6
    assert @gradation.valid?, "set points_earned to a valid float."

    @gradation.points_earned = -5
    assert !@gradation.valid?, "set points_earned to an invalid int."

    @gradation.points_earned = 16
    assert @gradation.valid?, "set points_earned to a valid int."
  end
  
  def test_gradation_points_earned_as_string
    @gradation.points_earned = 'E'  # = 'E'xcused assignment
    assert @gradation.valid?, "set points_earned to a valid String."

    @gradation.points_earned = 'M'  # = 'M'issing assignment
    assert @gradation.valid?, "set points_earned to a valid String."

    @gradation.points_earned = 'Q'  # = some invalid type
    assert !@gradation.valid?, "set points_earned to an invalid String."

    @gradation.points_earned = 'm'  # = lower case
    assert !@gradation.valid?, "set points_earned to an invalid String."

    @gradation.points_earned = 'Moo'  # = some invalid type but starts with a good string
    assert !@gradation.valid?, "set points_earned to an invalid String."

    @gradation.points_earned = 'MM'
    assert !@gradation.valid?, "set points_earned to an invalid String."

    @gradation.points_earned = 'This is a really long string'
    assert !@gradation.valid?, "set points_earned to a long String."
	end
	
	# Make sure that we can't have duplicates
  def test_gradation_duplicate_check
		gradation_copy = Gradation.new
		gradation_copy.student_id = @gradation.student_id
		gradation_copy.assignment_id = @gradation.assignment_id
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
