require File.dirname(__FILE__) + '/../test_helper'

class AuthenticationTest < ActionController::IntegrationTest

  # Administrator
  test "admin logging in with valid username and password" do
    visit root_path
    click_link "log in"
    fill_in "login", :with => "admin"
    fill_in "password", :with => "admin"
    click_button "Login"
    assert_contain "Login successful!"
    assert_contain "Admin"
  end

  test "admin logging in with invalid username" do
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

  test "admin logging in with invalid password" do
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

  # Teacher
  test "teacher logging in with valid username and password" do
    visit root_path
    click_link "log in"
    fill_in "login", :with => "teachera"
    fill_in "password", :with => "teachera"
    click_button "Login"
    assert_contain "Login successful!"
  end

  test "teacher logging in with invalid username" do
    visit root_path
    click_link "log in"
    fill_in "login", :with => "teachera"
    fill_in "password", :with => "badpassword"
    click_button "Login"
    assert_contain "Login failed!"
    assert_not_contain "Courses"
    assert_not_contain "Login is not valid"
    assert_not_contain "Password is not valid"
  end

  test "teacher logging in with invalid password" do
    visit root_path
    click_link "log in"
    fill_in "login", :with => "badteacher"
    fill_in "password", :with => "teachera"
    click_button "Login"
    assert_contain "Login failed!"
    assert_not_contain "Courses"
    assert_not_contain "Login is not valid"
    assert_not_contain "Password is not valid"
  end

  # Student
  test "student logging in with valid username and password" do
    visit root_path
    click_link "log in"
    fill_in "login", :with => "studenta"
    fill_in "password", :with => "studenta"
    click_button "Login"
    assert_contain "Login successful!"
    assert_contain "My Grades"
  end

  test "student logging in with invalid username" do
    visit root_path
    click_link "log in"
    fill_in "login", :with => "studenta"
    fill_in "password", :with => "badpassword"
    click_button "Login"
    assert_contain "Login failed!"
    assert_not_contain "My Grades"
    assert_not_contain "Login is not valid"
    assert_not_contain "Password is not valid"
  end

  test "student logging in with invalid password" do
    visit root_path
    click_link "log in"
    fill_in "login", :with => "badstudent"
    fill_in "password", :with => "studenta"
    click_button "Login"
    assert_contain "Login failed!"
    assert_not_contain "My Grades"
    assert_not_contain "Login is not valid"
    assert_not_contain "Password is not valid"
  end
end