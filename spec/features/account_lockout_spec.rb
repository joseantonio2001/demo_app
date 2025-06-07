require 'rails_helper'

RSpec.feature "Account Lockout", type: :feature do
    let!(:user) { User.create!(
        email: "test@example.com", 
        password: "SecurePassword123!", 
        username: "testuser"
    ) }

    scenario "User gets locked out after 5 failed login attempts" do
        # 5 intentos fallidos
        5.times do
        visit new_user_session_path
        fill_in "Email", with: user.email
        fill_in "Password", with: "wrong_password"
        click_button "Log in"
        end
        
        # Mensaje de cuenta bloqueada
        expect(page).to have_content("Your account is locked.")

        # Intentar iniciar sesión con las credenciales correctas (debería fallar)
        visit new_user_session_path
        fill_in "Email", with: user.email
        fill_in "Password", with: "SecurePassword123!"
        click_button "Log in"
        
        expect(page).to have_content("Your account is locked.")
    end
end