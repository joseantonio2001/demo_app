require 'rails_helper'

RSpec.feature "User Registration", type: :feature do
    scenario "User can register with valid credentials" do
        visit new_user_registration_path
        
        fill_in "Email", with: "test@example.com"
        fill_in "Password", with: "SecurePassword123!" # 12+ caracteres con mayúsculas, números y símbolos
        fill_in "Password confirmation", with: "SecurePassword123!"
        click_button "Sign up"
        
        expect(page).to have_content("Welcome! You have signed up successfully.")
        expect(User.count).to eq(1)
    end
    
    scenario "User cannot register with invalid credentials" do
        visit new_user_registration_path
        
        fill_in "Email", with: "invalid"
        fill_in "Password", with: "short"
        fill_in "Password confirmation", with: "mismatch"
        click_button "Sign up"
        
        # Esta línea se ajusta para que coincida con el mensaje exacto de Devise
        expect(page).to have_content("Password is too short (minimum is 12 characters)")
        expect(User.count).to eq(0)
    end
end