require File.dirname(__FILE__) + '/../test_helper'

class StudentTest < ActiveSupport::TestCase
	fixtures :users
	
	def setup
    @student = Student.first
    assert @student.valid?, 'The initial student is valid'
	end

	def teardown
	end
	
	def test_student_first_name_limits
		@student.first_name = "This is a really long name that probably shouldn't be legal because it is too long"
		assert !@student.valid?, "First Name too long" 	

		@student.first_name = ""
	 	assert !@student.valid?, "First Name too short"
	 	
	 	@student.first_name = "New"
	 	assert @student.valid?, "First Name just right" 	    
	end

	def test_student_last_name_limits
		@student.last_name = "This is a really long name that probably shouldn't be legal because it is too long"
		assert !@student.valid?, "Last Name too long" 	

		@student.last_name = ""
	 	assert !@student.valid?, "Last Name too short"
	 	
	 	@student.last_name = "Student"
	 	assert @student.valid?, "Last Name just right"
	end

  def test_student_class_of
    @student.class_of = ''
    assert !@student.valid?, 'Empty Class_Of is not valid'
    
    @student.class_of = 1900
    assert !@student.valid?, 'Class_Of 1900 is not valid'

    @student.class_of = Date.today.year + 30
    assert !@student.valid?, 'Future Class_Of is not valid'

    @student.class_of = Date.today.year + 2
    assert @student.valid?, 'Future Class_Of is valid'
  end

  def test_student_homeroom_limits
    @student.homeroom = ''
    assert @student.valid?, 'Empty homeroom is valid'
    
    @student.homeroom = 'Doesnt Exist'
    assert @student.valid?, 'Non-existant homeroom is valid'

    @student.homeroom = 'This is a really long homeroom that is longer than the max characters'
    assert !@student.valid?, 'Long homeroom is not valid'
  end
  
  def test_student_cannot_have_duplicates
    dup_user = Student.create(
                    :first_name => @student.first_name, 
                    :last_name => @student.last_name, 
                    :site => @student.site, 
                    :email => @student.email, 
                    :login => @student.login)
    assert !dup_user.save, "Duplicate Student is not valid"    
  end
  
end
