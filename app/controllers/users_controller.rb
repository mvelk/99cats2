class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
		@user = User.new(user_params)
		if @user.save
      msg = UserMailer.welcome_email(@user)
			msg.deliver
			redirect_to user_url(@user)
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password, :name, :email)
  end
end
