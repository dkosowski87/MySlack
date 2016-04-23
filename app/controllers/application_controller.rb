class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    elsif cookies[:remember_me_token]
      @current_user ||= User.find(cookies.permanent.encrypted[:remember_me_token])  	 
    end
  end

  def require_user
  	if current_user
  		true
  	else
  		redirect_to login_path
  	end
  end

  def find_team
    @team = current_user.team
  end

  def go_back_link(path)
    @go_back_link ||= path
  end

end