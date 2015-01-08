class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]

  def new
    render :new
  end

  def create
    user = User.find_by(username: session_params[:username])
    return flash.now[:error] = "username not found" if user.nil?
    if BCrypt::Password.new(user.password_digest).is_password?(session_params[:password])
      user.reset_session_token!
      session[:session_token] = user.session_token
      redirect_to cats_url
    else
      flash.now[:error] << "password didn't work"
      render :new
    end
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = ""
    redirect_to new_session_url
  end

  private
  def session_params
    params.require(:session).permit(:username, :password, :session_token)
  end
end
