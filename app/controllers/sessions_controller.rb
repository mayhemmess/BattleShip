class SessionsController < ApplicationController
  def new
  end


  # Create a new session, validating name/password combination
  def create
  	 user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
     log_in user
    

  # Set the board name in the chat as the current user.  
      current_user = User.find(session[:user_id])
      if(GlobalConstants::BOARDA.getName.to_s == "?")
        GlobalConstants::BOARDA.setName(current_user.name)
      else
        GlobalConstants::BOARDB.setName(current_user.name)
      end
  
  # Remembers the user if the "remember me"  box is checked. 
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
     redirect_to user
    else
      flash.now[:danger] = "Invalid name/password combination"
      render 'new'
    end
  end


  # Destroy the current session, (log out the user).
  def destroy
  	log_out if logged_in?
    redirect_to root_url

  end
end
