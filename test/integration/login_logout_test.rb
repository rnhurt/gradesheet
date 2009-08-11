require File.dirname(__FILE__) + '/../test_helper'

class LoginLogoutTest < ActionController::IntegrationTest

    def test_bad_password
      post "/user_sessions", :login => "teachera", :password => "badpass"
      assert_equal 'Login failed!', flash[:error]
      assert_response :success
      assert_template "user_sessions/new"
    end

  def test_teacher_login
    # Test the login route
    get login_path
    assert_response :success
    assert_template "user_sessions/new"

    # Login as a teacher
    post "/user_sessions", :user_session => {:login => "teachera", :password => "teachera"}
    #    Rails.logger.info session.inspect
    assert_equal 'Login successful!', flash[:notice]
    assert_response :redirect
    follow_redirect!
    assert_template "dashboard/index"

    # Try to go to a restricted page
    get "/courses"
    assert_response :success
    assert_template "courses/index"

    # But we shouldn't be able to hit an "admin" page
    get "/settings"
    assert_equal "You don't have the authority to access that page", flash[:error]
    assert_response :redirect
    follow_redirect!
    assert_template "dashboard/index"
  end

  def test_admin_login
    # Test the login route
    get login_path
    assert_response :success
    assert_template "user_sessions/new"

    # Login as an administrator
    post "/user_sessions", :user_session => {:login => "admin", :password => "admin"}
    #    Rails.logger.info session.inspect
    assert_equal 'Login successful!', flash[:notice]
    assert_response :redirect
    follow_redirect!
    assert_template "dashboard/index"

    # Try to go to a restricted page
    get "/courses"
    assert_response :success
    assert_template "courses/index"

    # Try to go to an "admin" only page
    get "/settings"
    assert_response :success
    assert_template "settings/index"
  end
end
