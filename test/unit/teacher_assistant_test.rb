require File.dirname(__FILE__) + '/../test_helper'

class TeacherAssistantTest < ActiveSupport::TestCase
	fixtures :users
	
	def setup
    @teacherass = TeacherAssistant.first
    assert @teacherass.valid?, 'The initial teacherass is valid'
	end

	def teardown
	end
	
	def test_user_first_name_limits
		@teacherass.first_name = "This is a really long name that probably shouldn't be legal because it is too long"
		assert !@teacherass.valid?, "First Name too long" 	

		@teacherass.first_name = ""
	 	assert !@teacherass.valid?, "First Name too short"
	 	
	 	@teacherass.first_name = "New"
	 	assert @teacherass.valid?, "First Name just right" 	    
	end

	def test_user_last_name_limits
		@teacherass.last_name = "This is a really long name that probably shouldn't be legal because it is too long"
		assert !@teacherass.valid?, "Last Name too long" 	

		@teacherass.last_name = ""
	 	assert !@teacherass.valid?, "Last Name too short"
	 	
	 	@teacherass.last_name = "Teacher"
	 	assert @teacherass.valid?, "Last Name just right"
	end

  def test_cannot_have_duplicate_users
    dup_user = TeacherAssistant.create(
                    :first_name => @teacherass.first_name, 
                    :last_name => @teacherass.last_name, 
                    :site => @teacherass.site, 
                    :email => @teacherass.email, 
                    :login => @teacherass.login)
    assert !dup_user.valid?, "Duplicate Teacher is not valid"    
  end
  
end
