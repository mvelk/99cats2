class SessionsController < ApplicationController
  #login screen
  def new
    @user = User.new
  end

  #This logs us in
  def create
    @user = User.find_by_credentials(session_params[:user_name],session_params[:password])
    if @user
      login_user!(@user)
      redirect_to cats_url
    else
      render :new
    end
  end
  #this logs us out
  def destroy
    logout!
    render :new
  end

  private
  def session_params
    params.require(:user).permit(:user_name,:password)
  end
end
