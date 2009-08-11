require File.dirname(__FILE__) + '/../test_helper'

class AssignmentCategoryTest < ActionController::IntegrationTest
  def setup
    # Login as an administrator
    post "/user_sessions", :user_session => {:login => "admin", :password => "admin"}
    #    Rails.logger.info session.inspect
    assert_equal 'Login successful!', flash[:notice]
  end
  
  def test_add_category
    # Create a new assignment type
    post "/settings/assignment_categories", :assignment_category => {:name => "Stinky"}
    assert_response :redirect
    follow_redirect!
    assert_template "index"

    # Verify the category exists
    category = AssignmentCategory.find_by_name("Stinky")
    assert_equal "Stinky", category.name
  end

  def test_delete_category
    # Find an existing assignment type
    category = AssignmentCategory.first()
    assert_instance_of(AssignmentCategory, category) 
    delete "/settings/assignment_categories/#{category.id}"
    assert_response :redirect
    follow_redirect!
    assert_template "index"

    # Verify the category has been deleted
    assert_raise(ActiveRecord::RecordNotFound) {
      AssignmentCategory.find(category.id)
    }
  end
end