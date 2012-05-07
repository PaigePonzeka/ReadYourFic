require 'test_helper'

class StoryshipsControllerTest < ActionController::TestCase
  setup do
    @storyship = storyships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:storyships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create storyship" do
    assert_difference('Storyship.count') do
      post :create, storyship: @storyship.attributes
    end

    assert_redirected_to storyship_path(assigns(:storyship))
  end

  test "should show storyship" do
    get :show, id: @storyship
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @storyship
    assert_response :success
  end

  test "should update storyship" do
    put :update, id: @storyship, storyship: @storyship.attributes
    assert_redirected_to storyship_path(assigns(:storyship))
  end

  test "should destroy storyship" do
    assert_difference('Storyship.count', -1) do
      delete :destroy, id: @storyship
    end

    assert_redirected_to storyships_path
  end
end
