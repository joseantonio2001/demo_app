# spec/features/complete_security_logging_spec.rb
require 'rails_helper'

RSpec.feature "Complete Security Logging Trajectory", type: :feature do
  # --- CONFIGURACIÓN INICIAL ---
  let(:security_log_path) { Rails.root.join('log', 'security.log') }
  let!(:regular_user) { create(:user, email: 'user@example.com', admin: false) }
  let!(:admin_user) { create(:user, email: 'admin@example.com', admin: true) }

  before do
    File.open(security_log_path, 'w') {}
  end

  context "when logging security events" do
    scenario "it correctly logs a failed login attempt" do
      visit new_user_session_path
      fill_in 'Email', with: regular_user.email
      fill_in 'Password', with: 'wrong_password'
      click_button 'Log in'

      log_content = File.read(security_log_path)
      expect(log_content).to include('"event":"failed_login_attempt"')
    end

    scenario "it correctly logs an authorization failure (Pundit)" do
      another_user = create(:user)
      post_by_another = create(:post, user: another_user)

      login_as(regular_user, scope: :user)
      visit edit_post_path(post_by_another)

      log_content = File.read(security_log_path)
      expect(log_content).to include('"event":"authorization_failure"')
    end

    scenario "it logs multiple failed attempts that result in an account lockout" do
      # Acción: Provocar 5 intentos fallidos
      5.times do |i|
        visit new_user_session_path
        fill_in 'Email', with: regular_user.email
        fill_in 'Password', with: "wrong_password_#{i}"
        click_button 'Log in'
      end

      # Verificación 1: La UI debe mostrar que la cuenta está bloqueada
      expect(page).to have_content("Your account is locked.")

      # Verificación 2: El log debe contener los 5 intentos fallidos
      log_content = File.read(security_log_path)
      expect(log_content.scan(/"event":"failed_login_attempt"/).count).to eq(5)
    end
  end

  context "when interacting with the log viewer UI" do
    scenario "an admin can see the log viewer link and access the page" do
      File.write(security_log_path, 'ADMIN_CAN_SEE_THIS_LOG_ENTRY', mode: 'a')

      login_as(admin_user, scope: :user)
      visit dashboard_path
      click_link 'View Security Logs'

      expect(page).to have_current_path(security_logs_dashboard_path)
      expect(page).to have_content("Security Event Logs")
      expect(page).to have_content("ADMIN_CAN_SEE_THIS_LOG_ENTRY")
    end

    scenario "a regular user cannot see the link or access the page" do
      login_as(regular_user, scope: :user)
      visit dashboard_path

      expect(page).not_to have_link('View Security Logs')

      visit security_logs_dashboard_path
      
      expect(page).to have_content("Acceso denegado. Se requiere ser administrador.")
    end
  end
end