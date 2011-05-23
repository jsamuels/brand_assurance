require 'test_helper'

class BrandColorsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:brand_colors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create brand_color" do
    assert_difference('BrandColor.count') do
      post :create, :brand_color => { }
    end

    assert_redirected_to brand_color_path(assigns(:brand_color))
  end

  test "should show brand_color" do
    get :show, :id => brand_colors(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => brand_colors(:one).to_param
    assert_response :success
  end

  test "should update brand_color" do
    put :update, :id => brand_colors(:one).to_param, :brand_color => { }
    assert_redirected_to brand_color_path(assigns(:brand_color))
  end

  test "should destroy brand_color" do
    assert_difference('BrandColor.count', -1) do
      delete :destroy, :id => brand_colors(:one).to_param
    end

    assert_redirected_to brand_colors_path
  end
end
