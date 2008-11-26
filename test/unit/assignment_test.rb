require File.dirname(__FILE__) + '/../test_helper'

class AssignmentTest < ActiveSupport::TestCase
  def setup
		# Do some setup here
		# FIXME
  end
  
  def test_assignment
  	# FIXME
  	course = Course.new
  	assignment_type = AssignmentType.new
  	assignment = Assignment.new :name => "Test", 
  								:course => course, 
  								:possible_points => "10",
  								:assignment_type => assignment_type
  								
#  	assert assignment.save
#  	
#  	assert assignment.name = ""
#  	assert assignment.
  end
end
