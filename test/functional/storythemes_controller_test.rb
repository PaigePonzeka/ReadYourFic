require 'test_helper'

class StorythemesControllerTest < ActionController::TestCase
  setup do
    @storytheme = storythemes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:storythemes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create storytheme" do
    assert_difference('Storytheme.count') do
      post :create, storytheme: @storytheme.attributes
    end

    assert_redirected_to storytheme_path(assigns(:storytheme))
  end

  test "should show storytheme" do
    get :show, id: @storytheme
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @storytheme
    assert_response :success
  end

  test "should update storytheme" do
    put :update, id: @storytheme, storytheme: @storytheme.attributes
    assert_redirected_to storytheme_path(assigns(:storytheme))
  end

  test "should destroy storytheme" do
    assert_difference('Storytheme.count', -1) do
      delete :destroy, id: @storytheme
    end

    assert_redirected_to storythemes_path
  end
end
