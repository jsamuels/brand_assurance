require 'test_helper'

class TolorancesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tolorances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tolorance" do
    assert_difference('Tolorance.count') do
      post :create, :tolorance => { }
    end

    assert_redirected_to tolorance_path(assigns(:tolorance))
  end

  test "should show tolorance" do
    get :show, :id => tolorances(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tolorances(:one).to_param
    assert_response :success
  end

  test "should update tolorance" do
    put :update, :id => tolorances(:one).to_param, :tolorance => { }
    assert_redirected_to tolorance_path(assigns(:tolorance))
  end

  test "should destroy tolorance" do
    assert_difference('Tolorance.count', -1) do
      delete :destroy, :id => tolorances(:one).to_param
    end

    assert_redirected_to tolorances_path
  end
end
