require 'rails_helper'

RSpec.feature "User Session", type: :feature do
  let(:user) { User.create(email: "test@example.com", password: "password123") }

  scenario "User can log in with valid credentials" do
    visit new_user_session_path
    
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log in"
    
    expect(page).to have_content("Signed in successfully.")
    expect(page).to have_current_path(root_path)
  end
  
  scenario "User can log out" do
    sign_in user
    visit root_path
    click_button "Logout"
    
    expect(page).to have_content("Signed out successfully.")
  end
end