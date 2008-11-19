require File.dirname(__FILE__) + '/../test_helper'

class StudentsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:students)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_student
    assert_difference('Student.count') do
      post :create, :student => { }
    end

    assert_redirected_to student_path(assigns(:student))
  end

  def test_should_show_student
    get :show, :id => students(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => students(:one).id
    assert_response :success
  end

  def test_should_update_student
    put :update, :id => students(:one).id, :student => { }
    assert_redirected_to student_path(assigns(:student))
  end

  def test_should_destroy_student
    assert_difference('Student.count', -1) do
      delete :destroy, :id => students(:one).id
    end

    assert_redirected_to students_path
  end
end
