# spec/features/post_sanitization_spec.rb
require 'rails_helper'

RSpec.feature "Strict Post Sanitization", type: :feature do
  include Warden::Test::Helpers

  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  scenario "User creates a post with HTML, which is stripped to plain text" do
    visit new_post_path

    fill_in "Title", with: "<b>Título Importante</b>"
    html_content = "<h2>Sub-encabezado</h2><p>Contenido limpio.</p><script>alert('XSS');</script>"
    fill_in "Content", with: html_content

    click_button "Create Post"

    # 1. VERIFICAR EL TÍTULO DE LA PÁGINA
    expect(page).to have_css("h1", text: "Título Importante")

    # 2. VERIFICAR EL ÁREA DE CONTENIDO DEL POST
    within(".post-content") do
      expect(page).to have_text("Sub-encabezado")
      expect(page).to have_text("Contenido limpio.")
      expect(page).not_to have_css("h2")
      expect(page).not_to have_css("p")
      expect(page).not_to have_css("script", visible: :all)
    end
    
    # 3. VERIFICAR LA BASE DE DATOS
    saved_post = Post.last
    expect(saved_post.title).to eq("Título Importante")
    
    # Usamos .squish para normalizar los espacios en blanco antes de la comparación.
    expect(saved_post.content.squish).to eq("Sub-encabezado Contenido limpio.")
  end
end