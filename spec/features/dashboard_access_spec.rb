require 'rails_helper'

RSpec.feature "Dashboard Access", type: :feature do
  let(:user) { User.create(email: "test@example.com", password: "password123") }

  scenario "Unauthenticated user is redirected to login" do
    visit dashboard_path
    
    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(page).to have_current_path(new_user_session_path)
  end
  
  scenario "Authenticated user can access dashboard" do
    sign_in user
    visit dashboard_path
    
    expect(page).to have_content("Dashboard")
    expect(page).to have_content("Welcome, #{user.email}!")
  end
end