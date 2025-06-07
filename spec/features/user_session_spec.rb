require 'rails_helper'

RSpec.feature "User Session", type: :feature do
    let!(:user) { User.create!(
        email: "test@example.com", 
        password: "SecurePassword123!", 
        username: "testuser"
    ) }

    scenario "User can log in with valid credentials" do
        visit new_user_session_path
        
        fill_in "Email", with: user.email
        fill_in "Password", with: "SecurePassword123!"
        click_button "Log in"
        
        expect(page).to have_content("Signed in successfully.")
    end
    
    scenario "User can log out" do
        login_as(user, scope: :user)
        
        visit root_path
        
        click_button "Cerrar Sesión" 
        
        expect(page).to have_content("Signed out successfully.")
    end
end