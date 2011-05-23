require 'test_helper'

class PrefsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prefs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pref" do
    assert_difference('Pref.count') do
      post :create, :pref => { }
    end

    assert_redirected_to pref_path(assigns(:pref))
  end

  test "should show pref" do
    get :show, :id => prefs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => prefs(:one).to_param
    assert_response :success
  end

  test "should update pref" do
    put :update, :id => prefs(:one).to_param, :pref => { }
    assert_redirected_to pref_path(assigns(:pref))
  end

  test "should destroy pref" do
    assert_difference('Pref.count', -1) do
      delete :destroy, :id => prefs(:one).to_param
    end

    assert_redirected_to prefs_path
  end
end
