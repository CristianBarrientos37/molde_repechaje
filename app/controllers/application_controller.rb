class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern


  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :phone, :user_type ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name,  :phone ])
  end

  def only_admin
    unless user_signed_in? && current_user.role == "admin"
      redirect_to root_path, notice: "No tienes permiso para realizar esta acción"
    end
  end

  private

  def authorize_admin
    unless current_user&.user_type == 'administrator'
      redirect_to root_path, alert: 'Solo administradores pueden realizar esta acción'
    end
  end
end
