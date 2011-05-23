require 'test_helper'

class PatchesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:patches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create patch" do
    assert_difference('Patch.count') do
      post :create, :patch => { }
    end

    assert_redirected_to patch_path(assigns(:patch))
  end

  test "should show patch" do
    get :show, :id => patches(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => patches(:one).to_param
    assert_response :success
  end

  test "should update patch" do
    put :update, :id => patches(:one).to_param, :patch => { }
    assert_redirected_to patch_path(assigns(:patch))
  end

  test "should destroy patch" do
    assert_difference('Patch.count', -1) do
      delete :destroy, :id => patches(:one).to_param
    end

    assert_redirected_to patches_path
  end
end
