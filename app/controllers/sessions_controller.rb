class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember_cookies(@user) : forget_cookies(@user)
      redirect_back_or @user
    else
      flash.now[:danger] = 'メールアドレスとパスワードが一致しません。'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def guest_login
    @user = User.guest
    log_in @user
    flash[:success] = "ゲストユーザーとしてログインしました。"
    redirect_to root_url
  end
end
