require File.dirname(__FILE__) + '/../test_helper'

class AssignmentTest < ActionController::IntegrationTest
  def setup
    visit root_path
    click_link "log in"
    fill_in "login", :with => "teachera"
    fill_in "password", :with => "teachera"
    click_button "Login"
    assert_contain "Login successful!"
  end

  test "enter a new assignment" do
    visit assignments_path
    click_link "English"
    click_link "add_assignment"
    fill_in "assignment_name",            :with => "Spelling Test"
    fill_in "assignment_possible_points", :with => "100"
    fill_in "assignment_due_date",        :with => Time.now.strftime("%Y-%m-%d 00:00:01")
    select "Test", :from => "assignment_assignment_category_id"
    click_button "Save"
    assert_contain "Assignment 'Spelling Test' was created successfully."
  end

end
