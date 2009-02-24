require File.dirname(__FILE__) + '/../test_helper'

class GradationTest < ActiveSupport::TestCase
#	fixtures :assignments, :users
#	
#	def setup
#    @gradation = Gradation.new

#    student = Student.find(:last)
#		assert_not_nil student
#    @gradation.student_id = student.id

#    assignment = Assignment.find(:last)
#		assert_not_nil assignment
#    @gradation.assignment_id = assignment.id

#    @gradation.points_earned = 100
#		
#		assert @gradation.save, "SAVE gradation"
#	end
#	def teardown
#		assert @gradation.destroy, "DESTROY gradation"
#	end

#	# Make sure that we have EITHER a valid points_earned
#	# or a flag has been set telling us why
#  def test_gradation_points_or_flags
#    @gradation.points_earned = nil
#    @gradation.flag = nil
#    assert !@gradation.save, "Neither points_earned nor flag has been set."
#    
#    @gradation.points_earned = 5.3
#    @gradation.flag = nil
#    assert @gradation.save, "points_earned has been set."
#    
#    @gradation.points_earned = nil
#    @gradation.flag = 'E'
#    assert @gradation.save, "flag has been set."
#	end

#	# Make sure that we only accept valid students & assignments
#  def test_gradation_validates_presence_of
#    @gradation.student_id = -1
#    assert !@gradation.save, "Bad student_id"

#    @gradation.assignment_id = -1
#    assert !@gradation.save, "Bad assignment_id"
#	end

#	# Make sure we can not have invalid points_earned
#  def test_gradation_invalid_points_earned
#    @gradation.points_earned = -1.4
#    assert !@gradation.save, "Negative points_earned."

#    @gradation.points_earned = 'E'
#    assert !@gradation.save, "String points_earned."

#    @gradation.points_earned = 1.6
#    assert @gradation.save, "Valid points_earned."
#	end
#	
#	# Make sure that we can't have duplicates
#  def test_gradation_duplicate_check
#		gradation_copy = Gradation.new
#		gradation_copy.student_id = @gradation.student_id
#		gradation_copy.assignment_id = @gradation.assignment_id
#		gradation_copy.points_earned = 666
#		
#		assert !gradation_copy.save, "Duplicate not allowed"
#	end
end
