require File.dirname(__FILE__) + '/../test_helper'

class TeacherTest < ActiveSupport::TestCase
	fixtures :all
	
	def setup
    @teacher = Teacher.find_by_login("teachera")
    assert @teacher.valid?, 'The initial teacher is valid'
	end

	def teardown
	end
	
	def test_user_first_name_limits
		@teacher.first_name = "This is a really long name that probably shouldn't be legal because it is too long"
		assert !@teacher.valid?, "First Name too long" 	

		@teacher.first_name = ""
	 	assert !@teacher.valid?, "First Name too short"
	 	
	 	@teacher.first_name = "New"
	 	assert @teacher.valid?, "First Name just right" 	    
	end

	def test_user_last_name_limits
		@teacher.last_name = "This is a really long name that probably shouldn't be legal because it is too long"
		assert !@teacher.valid?, "Last Name too long" 	

		@teacher.last_name = ""
	 	assert !@teacher.valid?, "Last Name too short"
	 	
	 	@teacher.last_name = "Teacher"
	 	assert @teacher.valid?, "Last Name just right"
	end

  def test_cannot_have_duplicate_users
    dup_user = Teacher.create(
                    :first_name => @teacher.first_name, 
                    :last_name => @teacher.last_name, 
                    :site => @teacher.site, 
                    :email => @teacher.email, 
                    :login => @teacher.login)
    assert !dup_user.valid?, "Duplicate Teacher is not valid"    
  end
  
end
