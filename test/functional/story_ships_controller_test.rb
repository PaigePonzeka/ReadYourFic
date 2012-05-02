require 'test_helper'

class StoryShipsControllerTest < ActionController::TestCase
  setup do
    @story_ship = story_ships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:story_ships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create story_ship" do
    assert_difference('StoryShip.count') do
      post :create, story_ship: @story_ship.attributes
    end

    assert_redirected_to story_ship_path(assigns(:story_ship))
  end

  test "should show story_ship" do
    get :show, id: @story_ship
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @story_ship
    assert_response :success
  end

  test "should update story_ship" do
    put :update, id: @story_ship, story_ship: @story_ship.attributes
    assert_redirected_to story_ship_path(assigns(:story_ship))
  end

  test "should destroy story_ship" do
    assert_difference('StoryShip.count', -1) do
      delete :destroy, id: @story_ship
    end

    assert_redirected_to story_ships_path
  end
end
