class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotSaved, with: :render_file_not_found

  def render_file_not_found
    render file: 'public/404.html', status: :not_found, layout: false
  end

  def require_user
    if current_user
      true
    else
      redirect_to login_path
    end
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    elsif cookies[:remember_me_token]
      @current_user ||= User.find(cookies.encrypted[:remember_me_token])  	 
    end
  end

  def find_current_user_team
    @team = current_user.team
  end

  def go_back_link(path)
    @go_back_link ||= path
  end

end