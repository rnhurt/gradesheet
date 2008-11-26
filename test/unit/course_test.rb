require File.dirname(__FILE__) + '/../test_helper'

class CourseTest < ActiveSupport::TestCase
	## TODO: Make more complete by adding in required models
	fixtures :courses, :course_types
	
  def test_course
    
    course = Course.new :name => "Math 8H"
    assert !course.save
    
    course_type = CourseType.find(:first, :conditions => "name = 'Home Room'")
    course.course_type = course_type
    assert !course.save
    
#    course_copy = Course.find(course.id)
#    assert_equal course.name, course_copy.name

#		assert course.destroy
	end
	
	def test_course_name_length
		## FIXME: This test is just a stub
		#course = Course.new :name => "This is a really long name that probably shouldn't be legal because it is too long"
  	#assert !course.valid?, "Name too long" 	

		#course.name = ""
	 	#assert !course.valid?, "Name too short" 	
		
		#assert course.destroy
  end
end
