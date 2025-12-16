class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :initialize_cart
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def initialize_cart
    session[:cart] ||= {}
  end

  # 🔐 ДОЗВІЛ ДЛЯ username
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
