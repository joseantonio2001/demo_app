class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    # Extrae información detallada de la excepción para el log.
    policy_name = exception.policy.class.to_s.underscore
    query = exception.query

    # Crea un mensaje de log estructurado en formato JSON.
    log_message = {
      event: 'authorization_failure',
      user: current_user&.id,
      email: current_user&.email,
      policy: policy_name,
      action: query,
      ip_address: request.remote_ip,
      path: request.path
    }.to_json

    # Escribe el evento en el log de seguridad dedicado.
    SECURITY_LOGGER.error(log_message)

    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end
end