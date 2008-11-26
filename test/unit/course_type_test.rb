require File.dirname(__FILE__) + '/../test_helper'

class CourseTypeTest < ActiveSupport::TestCase

  def test_course_type
  	course_type = CourseType.new :name => "Home Room"
  	assert course_type.save
  	
  	course_type_copy = CourseType.find(course_type.id)
  	assert_equal course_type.name, course_type_copy.name

		assert course_type.destroy
  end
  
 	def test_course_type_name_length
		course_type = CourseType.new :name => "This is a really long course_type name that probably shouldn't be legal because it is too long"
  	assert !course_type.valid?, "Course_Type name too long" 	

		course_type.name = ""
	 	assert !course_type.valid?, "Course_Type name too short" 	
		
		assert course_type.destroy
  end

end
