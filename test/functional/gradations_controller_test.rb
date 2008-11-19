require File.dirname(__FILE__) + '/../test_helper'

class GradationsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:gradations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_gradation
    assert_difference('Gradation.count') do
      post :create, :gradation => { }
    end

    assert_redirected_to gradation_path(assigns(:gradation))
  end

  def test_should_show_gradation
    get :show, :id => gradations(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => gradations(:one).id
    assert_response :success
  end

  def test_should_update_gradation
    put :update, :id => gradations(:one).id, :gradation => { }
    assert_redirected_to gradation_path(assigns(:gradation))
  end

  def test_should_destroy_gradation
    assert_difference('Gradation.count', -1) do
      delete :destroy, :id => gradations(:one).id
    end

    assert_redirected_to gradations_path
  end
end
