class UsersController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:session_token] = @user.session_token
      redirect_to cats_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def new
    @user = User.new
    render :new
  end

  def show
    render :show
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :session_token)
  end

end
