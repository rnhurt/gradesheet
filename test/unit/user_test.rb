require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  # Tests should be run in the sub-classes (Student, Teacher, etc.)
#	fixtures :users, :sites
#	
#	def setup
#    @user = User.first
#    @site = Site.first
#	end

#	def teardown
#	end
#	
#	def test_user_first_name_limits
#		@user.first_name = "This is a really long name that probably shouldn't be legal because it is too long"
#		assert !@user.valid?, "First Name too long" 	

#		@user.first_name = ""
#	 	assert !@user.valid?, "First Name too short"
#	 	
#	 	@user.first_name = "New"
#	 	assert @user.valid?, "First Name just right" 	    
#	end

#	def test_user_last_name_limits
#		@user.last_name = "This is a really long name that probably shouldn't be legal because it is too long"
#		assert !@user.valid?, "Last Name too long" 	

#		@user.last_name = ""
#	 	assert !@user.valid?, "Last Name too short"
#	 	
#	 	@user.last_name = "Student"
#	 	assert @user.valid?, "Last Name just right"
#	end

#  def test_cannot_have_duplicate_users
#    dup_user = User.create(:first_name => 'Test', :last_name => 'Teacher', :site => @site, :email => '', :short_name => '')
#    assert dup_user.valid?
#    
#    assert !dup_user.save
#  end
end
