require 'test_helper'

class ChatControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_select "title", "Chat | BattleShip"
  end


end