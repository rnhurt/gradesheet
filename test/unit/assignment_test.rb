require File.dirname(__FILE__) + '/../test_helper'

class AssignmentTest < ActiveSupport::TestCase
	fixtures :all

  def setup
    @course = Course.first 
    assert @course.valid?, "Initial course is valid"

    @assignment = Assignment.first
    @assignment.due_date = Date.today
    assert @assignment.valid?, "Initial assignment is valid"
 	end
	def teardown
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
  	course_term = CourseTerm.first
  	assert_not_nil course_term
  	@assignment.course_term = course_term
  	assert @assignment.valid?, "Valid course_term"
  end
  
  test "assigment due date" do
  	@assignment.due_date_formated = "Dec 12, 2009"
  	assert @assignment.valid?, "Due date is valid"
  	
  	@assignment.due_date_formated = "Dec 33, 2009"
  	assert !@assignment.valid?, "Due date is invalid"

    @assignment.due_date = ''
    assert !@assignment.valid?, "Due date is null"
  end

end
