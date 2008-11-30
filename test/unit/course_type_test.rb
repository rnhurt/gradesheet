require File.dirname(__FILE__) + '/../test_helper'

class CourseTypeTest < ActiveSupport::TestCase
	def setup
  	@course_type = CourseType.new :name => "Home Room"
  	assert @course_type.save, "SAVE course_type"
	end
	def teardown
		assert @course_type.destroy, "DESTROY course_type"
	end


  def test_course_type  	
  	course_type_copy = CourseType.find(@course_type.id)
  	assert_equal @course_type.name, course_type_copy.name
  end
  
 	def test_course_type_name_length
		@course_type.name = "This is a really long course_type name that probably shouldn't be legal because it is too long"
  	assert !@course_type.valid?, "Course_Type name too long" 	

		@course_type.name = ""
	 	assert !@course_type.valid?, "Course_Type name too short" 	

		@course_type.name = "Test Course"
	 	assert @course_type.valid?, "Course_Type is just right" 	
  end

end
