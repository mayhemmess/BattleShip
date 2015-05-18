require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Home | BattleShip"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | BattleShip"
  end

end
