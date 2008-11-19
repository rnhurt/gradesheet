require File.dirname(__FILE__) + '/../test_helper'

class TeachersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:teachers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_teacher
    assert_difference('Teacher.count') do
      post :create, :teacher => { }
    end

    assert_redirected_to teacher_path(assigns(:teacher))
  end

  def test_should_show_teacher
    get :show, :id => teachers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => teachers(:one).id
    assert_response :success
  end

  def test_should_update_teacher
    put :update, :id => teachers(:one).id, :teacher => { }
    assert_redirected_to teacher_path(assigns(:teacher))
  end

  def test_should_destroy_teacher
    assert_difference('Teacher.count', -1) do
      delete :destroy, :id => teachers(:one).id
    end

    assert_redirected_to teachers_path
  end
end
