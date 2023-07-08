class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def authenticate_admin!
    return if user_signed_in? && current_user.admin?

    redirect_to root_path, notice: 'Você não tem permissão para essa ação'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name sex social_name cpf])
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path, notice: 'Você precisa estar logado para concluir essa ação'
    end
  end
end
