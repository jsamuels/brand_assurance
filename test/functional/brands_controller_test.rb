require 'test_helper'

class BrandsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:brands)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create brands" do
    assert_difference('Brands.count') do
      post :create, :brands => { }
    end

    assert_redirected_to brands_path(assigns(:brands))
  end

  test "should show brands" do
    get :show, :id => brands(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => brands(:one).to_param
    assert_response :success
  end

  test "should update brands" do
    put :update, :id => brands(:one).to_param, :brands => { }
    assert_redirected_to brands_path(assigns(:brands))
  end

  test "should destroy brands" do
    assert_difference('Brands.count', -1) do
      delete :destroy, :id => brands(:one).to_param
    end

    assert_redirected_to brands_path
  end
end
