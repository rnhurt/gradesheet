require File.dirname(__FILE__) + '/../test_helper'

class EnrollmentTest < ActiveSupport::TestCase
	def setup
		@course = Course.first()
		@student = Student.first()
	end
	
	def teardown
		
	end
	
	def test_unique_course_student_combination
		@course
	end
	
end
