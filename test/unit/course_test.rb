require File.dirname(__FILE__) + '/../test_helper'

class CourseTest < ActiveSupport::TestCase
	fixtures :courses, :course_types, :terms, :users
	
	def setup
    @course = Course.new :name => "Math 8H"

    course_type = CourseType.find(:first, :conditions => "name = 'Home Room'")
		assert_not_nil course_type
    @course.course_type = course_type

		teacher = Teacher.find(:first)
		assert_not_nil teacher
		@course.teacher = teacher
		
		term = Term.find(:first)
		assert_not_nil term
		@course.term = term
		
		grading_scale = GradingScale.find(:first)
		assert_not_nil grading_scale
		@course.grading_scale = grading_scale
		
		assert @course.save, "SAVE course"
	end
	def teardown
		assert @course.destroy, "DESTROY course"
	end
	
	
  def test_course_copy_and_find
    course_copy = Course.find(@course.id)
    assert_equal @course.name, course_copy.name
	end
	
	def test_course_name_length
		@course.name = "This is a really long name that probably shouldn't be legal because it is too long"
		assert !@course.valid?, "Name too long" 	

		@course.name = ""
	 	assert !@course.valid?, "Name too short"
	 	
	 	@course.name = "Math 8H"
	 	assert @course.valid?, "Name just right" 	
  end
  
  def test_course_uniqueness
		# TODO: test to make sure a teacher cannot be in multiple courses with
		# the same name in the same term.
  	assert true
  end
end
