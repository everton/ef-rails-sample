class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  before_action :save_return_path

  private
  def self.require_admin(options = {})
    require_login(options)

    before_filter(options) do
      require_admin! unless current_user.admin?
    end
  end

  def self.require_login(options = {})
    before_filter(options) do
      require_login! unless logged_in?
    end
  end

  def require_login!
    redirect_to login_path,
      alert: 'To access this page you must be logged'
  end

  def require_admin!
    redirect_to '/',
      alert: "You don't have access to this page"
  end

  def save_return_path
    session[:return_path] = request.post? ? root_path : request.path
  end

  def logged_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
