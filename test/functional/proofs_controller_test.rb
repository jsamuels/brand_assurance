require 'test_helper'

class ProofsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proofs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proof" do
    assert_difference('Proof.count') do
      post :create, :proof => { }
    end

    assert_redirected_to proof_path(assigns(:proof))
  end

  test "should show proof" do
    get :show, :id => proofs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => proofs(:one).to_param
    assert_response :success
  end

  test "should update proof" do
    put :update, :id => proofs(:one).to_param, :proof => { }
    assert_redirected_to proof_path(assigns(:proof))
  end

  test "should destroy proof" do
    assert_difference('Proof.count', -1) do
      delete :destroy, :id => proofs(:one).to_param
    end

    assert_redirected_to proofs_path
  end
end
