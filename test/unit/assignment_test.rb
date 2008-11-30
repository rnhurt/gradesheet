require File.dirname(__FILE__) + '/../test_helper'

class AssignmentTest < ActiveSupport::TestCase
	fixtures :courses, :course_types, :assignment_types

  def setup
  	course = Course.new
  	assignment_type = AssignmentType.new
  	@assignment = Assignment.new :name => "Test", 
  								:course => course, 
  								:possible_points => "10",
  								:assignment_type => assignment_type
		
		assert assignment.save
  end
  
	def test_assignment_name_length
		@assignment.name = "This is a really long name that probably shouldn't be legal because it is too long"
		assert !@assignment.valid?, "Name too long" 	

		@assignment.name = ""
	 	assert !@assignment.valid?, "Name too short"
	 	
	 	@assignment.name = "Math 8H"
	 	assert @assignment.valid?, "Name just right" 	
  end
end
