require File.dirname(__FILE__) + '/../test_helper'

class AssignmentTest < ActiveSupport::TestCase
	fixtures :courses, :course_types, :assignment_types

  def setup 
 		@assignment = Assignment.find(:first)
 			
		assert @assignment.save, "SAVE assignment"
  end
  def teardown
  	assert @assignment.destroy, "DESTROY assignment"
  end
  
  
	def test_assignment_name_length
		@assignment.name = "This is a really long name that probably shouldn't be legal because it is too long"
		assert !@assignment.valid?, "Name too long" 	

		@assignment.name = ""
	 	assert !@assignment.valid?, "Name too short"
	 	
	 	@assignment.name = "Math 8H"
	 	assert @assignment.valid?, "Name just right" 	
  end
  
  def test_assignment_possible_points
  	@assignment.possible_points = "ABC"
	 	assert !@assignment.valid?, "Points non numerical" 	

  	@assignment.possible_points = ""
	 	assert !@assignment.valid?, "Points are missing" 	
  	
  	@assignment.possible_points = "100.00"
	 	assert @assignment.valid?, "Floating points are valid" 	

  	@assignment.possible_points = "0"
	 	assert @assignment.valid?, "0 points are valid" 	

  	@assignment.possible_points = "20982403572985352353252354"
	 	assert @assignment.valid?, "Large number of points"
	 	
	 	@assignment.possible_points = "111"
	 	assert @assignment.valid?, "Points are integers" 	
  end
  
  def test_assignment_requires_a_valid_course
  	course = Course.new :name => "New Course"
  	@assignment.course_id = course.id
  	assert !@assignment.valid?, "Invalid course"
  	
  	course = Course.find(:first)
  	@assignment.course_id = course.id
  	assert @assignment.valid?, "Valid course"
  end
  
  def test_assignment_due_date_format
  	# FIXME: date checking is hard
  	@assignment.due_date_formated = "Dec 12, 2009"
  	assert @assignment.valid?, "Due date is valid"
  	
  	@assignment.due_date_formated = "99, 99 2009"
  	assert !@assignment.valid?, "Due date is invalid"
  	
  end
end
