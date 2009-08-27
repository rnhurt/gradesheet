require File.dirname(__FILE__) + '/../test_helper'

class AuthenticationTest < ActionController::IntegrationTest
  fixtures :all
  
  test "logging in with valid username and password" do
    visit root_path
    click_link "log in"
    fill_in "login", :with => "admin"
    fill_in "password", :with => "admin"
    click_button "Login"
    assert_contain "Login successful!"
    assert_contain "Admin"
  end

  test "logging in with invalid username" do
    visit root_path
    click_link "log in"
    fill_in "login", :with => "admin"
    fill_in "password", :with => "badadmin"
    click_button "Login"
    assert_contain "Login failed!"
    assert_not_contain "Admin"
    assert_not_contain "Login is not valid"
    assert_not_contain "Password is not valid"   
  end

  test "logging in with invalid password" do
    visit root_path
    click_link "log in"
    fill_in "login", :with => "badadmin"
    fill_in "password", :with => "admin"
    click_button "Login"
    assert_contain "Login failed!"
    assert_not_contain "Admin"
    assert_not_contain "Login is not valid"
    assert_not_contain "Password is not valid"   
  end
  
end