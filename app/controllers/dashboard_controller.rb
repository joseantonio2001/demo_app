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
  
end