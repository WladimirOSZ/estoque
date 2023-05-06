class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?


  def authenticate_admin!
    unless user_signed_in? && current_user.admin?
      redirect_to root_path, notice: 'Você não tem permissão para essa ação'
    end
  end

  

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :sex, :social_name])
  end
end
