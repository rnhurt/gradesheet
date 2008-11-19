require File.dirname(__FILE__) + '/../test_helper'

class UserTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:user_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_user_type
    assert_difference('UserType.count') do
      post :create, :user_type => { }
    end

    assert_redirected_to user_type_path(assigns(:user_type))
  end

  def test_should_show_user_type
    get :show, :id => user_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => user_types(:one).id
    assert_response :success
  end

  def test_should_update_user_type
    put :update, :id => user_types(:one).id, :user_type => { }
    assert_redirected_to user_type_path(assigns(:user_type))
  end

  def test_should_destroy_user_type
    assert_difference('UserType.count', -1) do
      delete :destroy, :id => user_types(:one).id
    end

    assert_redirected_to user_types_path
  end
end
