require 'test_helper'

class TolerancesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tolerances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tolerance" do
    assert_difference('Tolerance.count') do
      post :create, :tolerance => { }
    end

    assert_redirected_to tolerance_path(assigns(:tolerance))
  end

  test "should show tolerance" do
    get :show, :id => tolerances(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tolerances(:one).to_param
    assert_response :success
  end

  test "should update tolerance" do
    put :update, :id => tolerances(:one).to_param, :tolerance => { }
    assert_redirected_to tolerance_path(assigns(:tolerance))
  end

  test "should destroy tolerance" do
    assert_difference('Tolerance.count', -1) do
      delete :destroy, :id => tolerances(:one).to_param
    end

    assert_redirected_to tolerances_path
  end
end
