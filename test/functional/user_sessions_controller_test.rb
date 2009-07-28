require File.dirname(__FILE__) + '/../test_helper'

class UserSessionsControllerTest < ActionController::TestCase

  def test_create_user_session
    post :create, :user_session => { :login => "teachera", :password => "teachera" }
    assert user_session = UserSession.find
    assert_equal users(:teachera), user_session.user
    assert_redirected_to "/dashboard"
  end

end
