class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @api_key = Rails.application.credentials.dig(:api_key)
  end
end