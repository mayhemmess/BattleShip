class UsersController < ApplicationController

  # Method to show the stats of the user logged in.
  def show
  	@user = User.find(params[:id])
  end

  # Method to create a new user.
  def new
  	@user = User.new
  end
 
  # Method that create a new user and initialize it with its corresponding attributes.
  def create
  	@user = User.new(user_params)
  	@user.win=0
  	@user.draw=0
  	@user.lose=0
  	if @user.save
      log_in @user
      flash[:success] = "Welcome to BattleShip"
      redirect_to @user
  	else
  		render 'new'
  	end
end

private


 # Method that validates that only name, password and password confirmation can be submitted.
def user_params
	params.require(:user).permit(:name,:password,:password_confirmation)
end

end
