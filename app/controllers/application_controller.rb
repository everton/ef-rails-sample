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
    if request.format.html?
      redirect_to login_path,
        alert: 'To access this page you must be logged'
    else
      require_http_login!
    end
  end

  def require_http_login!
    authenticate_with_http_basic do |u, p|
      @current_user = User.where(email: u).first.try(:authenticate, p)
    end

    request_http_basic_authentication unless @current_user
  end

  def require_admin!
    redirect_to '/',
      alert: "You don't have access to this page"
  end

  def save_return_path
    session[:return_path] = request.get? ? request.path : root_path
  end

  def logged_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end
end
