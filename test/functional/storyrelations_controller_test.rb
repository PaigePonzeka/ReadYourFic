require 'test_helper'

class StoryrelationsControllerTest < ActionController::TestCase
  setup do
    @storyrelation = storyrelations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:storyrelations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create storyrelation" do
    assert_difference('Storyrelation.count') do
      post :create, storyrelation: @storyrelation.attributes
    end

    assert_redirected_to storyrelation_path(assigns(:storyrelation))
  end

  test "should show storyrelation" do
    get :show, id: @storyrelation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @storyrelation
    assert_response :success
  end

  test "should update storyrelation" do
    put :update, id: @storyrelation, storyrelation: @storyrelation.attributes
    assert_redirected_to storyrelation_path(assigns(:storyrelation))
  end

  test "should destroy storyrelation" do
    assert_difference('Storyrelation.count', -1) do
      delete :destroy, id: @storyrelation
    end

    assert_redirected_to storyrelations_path
  end
end
