require File.dirname(__FILE__) + '/../test_helper'

class CoursesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:courses)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_course
    assert_difference('Course.count') do
      post :create, :course => { }
    end

    assert_redirected_to course_path(assigns(:course))
  end

  def test_should_show_course
    get :show, :id => courses(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => courses(:one).id
    assert_response :success
  end

  def test_should_update_course
    put :update, :id => courses(:one).id, :course => { }
    assert_redirected_to course_path(assigns(:course))
  end

  def test_should_destroy_course
    assert_difference('Course.count', -1) do
      delete :destroy, :id => courses(:one).id
    end

    assert_redirected_to courses_path
  end
end
