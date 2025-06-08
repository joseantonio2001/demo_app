# spec/features/post_authorization_spec.rb
require 'rails_helper'

RSpec.feature "PostAuthorization", type: :feature do
  include Warden::Test::Helpers

  let!(:user_one) { create(:user) }
  let!(:user_two) { create(:user) }
  let!(:post_by_user_one) { create(:post, user: user_one, title: 'Post by User One') }

  # Escenario 1: Un invitado (no logueado)
  context "as a guest" do
    scenario "is redirected when trying to create a new post" do
      visit new_post_path

      # Devise debe redirigir al login
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end

    scenario "can view the posts index and a single post" do
      visit posts_path
      expect(page).to have_content(post_by_user_one.title)

      click_link post_by_user_one.title
      expect(page).to have_current_path(post_path(post_by_user_one))
    end
  end

  # Escenario 2: Un usuario logueado
  context "as a logged-in user" do
    before do
      login_as(user_two, scope: :user)
    end

    scenario "can create a new post" do
      visit new_post_path
      
      # El usuario está autorizado, por lo que debe ver el formulario
      expect(page).to have_current_path(new_post_path)

      fill_in "Title", with: "My Awesome Post"
      fill_in "Content", with: "This is my content."
      click_button "Create Post"

      expect(page).to have_content("Post was successfully created.")
      expect(page).to have_content("My Awesome Post")
    end

    scenario "is redirected when trying to edit another user's post" do
      visit edit_post_path(post_by_user_one)
      
      # Pundit debe redirigir a la raíz y mostrar un error
      expect(page).to have_current_path(root_path)
      expect(page).to have_content("No tienes autorización para realizar esta acción.")
    end
  end

  # Escenario 3: El dueño del post
  context "as the post owner" do
    before do
      login_as(user_one, scope: :user)
    end

    scenario "can edit their own post" do
      visit edit_post_path(post_by_user_one)
      
      # El dueño está autorizado, debe ver el formulario de edición
      expect(page).to have_current_path(edit_post_path(post_by_user_one))
      
      fill_in "Title", with: "My Updated Title"
      click_button "Update Post"
      
      expect(page).to have_content("Post was successfully updated.")
      expect(page).to have_content("My Updated Title")
    end
  end
end