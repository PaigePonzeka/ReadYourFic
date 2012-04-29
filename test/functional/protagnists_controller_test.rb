require 'test_helper'

class ProtagnistsControllerTest < ActionController::TestCase
  setup do
    @protagnist = protagnists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:protagnists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create protagnist" do
    assert_difference('Protagnist.count') do
      post :create, protagnist: @protagnist.attributes
    end

    assert_redirected_to protagnist_path(assigns(:protagnist))
  end

  test "should show protagnist" do
    get :show, id: @protagnist
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @protagnist
    assert_response :success
  end

  test "should update protagnist" do
    put :update, id: @protagnist, protagnist: @protagnist.attributes
    assert_redirected_to protagnist_path(assigns(:protagnist))
  end

  test "should destroy protagnist" do
    assert_difference('Protagnist.count', -1) do
      delete :destroy, id: @protagnist
    end

    assert_redirected_to protagnists_path
  end
end
