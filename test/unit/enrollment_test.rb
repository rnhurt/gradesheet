require File.dirname(__FILE__) + '/../test_helper'

class EnrollmentTest < ActiveSupport::TestCase
	def setup
		@course = Course.first
    assert @course.valid?, 'The initial course is valid'

		@student = Student.first
    assert @student.valid?, 'The initial student is valid'
	end
	
	def teardown
		
	end
	
	def test_unique_course_student_combination
		@course
	end
	
end
