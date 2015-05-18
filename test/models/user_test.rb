require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
  	@user = User.new(name: "Raul", win: 2, draw: 0, lose: 1, 
  		password: "123456", password_confirmation: "123456")
  end

 test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
  	@user.name = " "
  	assert_not @user.valid?
  end
  
   test "name should not be too short" do
    @user.name = "a" * 2
    assert_not @user.valid?
  end

 

   test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
  
end
