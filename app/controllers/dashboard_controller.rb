require 'bundler/audit/scanner'
require 'bundler/audit/database'

class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @api_key = Rails.application.credentials.dig(:api_key)
  end

  def dependency_audit
    # Actualiza la base de datos de vulnerabilidades (puede tardar un momento)
    Bundler::Audit::Database.update!(quiet: true)
    
    # Crea un nuevo scanner y ejecuta el escaneo
    scanner = Bundler::Audit::Scanner.new
    
    # Asigna los resultados a la variable @results para usarla en la vista
    @results = scanner.scan.to_a
  end

  def security_logs
    # Esta línea asegura que solo los usuarios administradores puedan acceder.
    # Asumimos que tu modelo User tiene un campo booleano `admin`.
    unless current_user.admin?
      redirect_to dashboard_path, alert: 'Acceso denegado. Se requiere ser administrador.'
      return
    end

    log_file = Rails.root.join('log', 'security.log')
    @security_events = []
    if File.exist?(log_file)
      @security_events = File.readlines(log_file).last(50).reverse
    end
  end
end