require 'rails_helper'

RSpec.feature "Secure Credentials Feature", type: :feature do
  let(:admin_user) { create(:user, admin: true) }

  before do
    # Inicia sesión el usuario antes de cada prueba
    login_as(admin_user, scope: :user)

    # Stub Rails credentials para aislar el test. Esto está perfecto.
    allow(Rails.application).to receive(:credentials).and_return({
      api_key: 'test_key_from_spec'
    })
  end

  scenario "an authenticated user sees the secret-derived information on the dashboard" do
    # 1. Visitar la página
    visit dashboard_path

    # 2. Verificar el contenido visible por defecto
    expect(page).to have_content("Secrets Integration Status:")
    expect(page).to have_css(".badge.bg-success", text: "SUCCESS")

    # 3. Simular el clic del usuario para abrir el desplegable
    find('summary', text: "Show Secret Key (demo only)").click

    # 4. Ahora que está visible, verificar el contenido del desplegable
    # Es mejor usar selectores más específicos que `have_content` para evitar falsos positivos.
    within('details') do
      expect(page).to have_selector("code", text: "test_key_from_spec")
      expect(page).to have_content("Important: Never expose secrets in the front-end.")
    end
  end

  scenario "an authenticated user sees an error if the secret is missing" do
    # Probemos el caso de fallo para estar seguros
    allow(Rails.application).to receive(:credentials).and_return({
      # Simulamos que api_key no está definida
      api_key: nil 
    })
    
    visit dashboard_path

    expect(page).to have_content("Secrets Integration Status:")
    expect(page).to have_css(".badge.bg-danger", text: "ERROR")
    expect(page).to have_content("Could not load the api_key.")
    expect(page).not_to have_content("Show Secret Key") # El desplegable no debería aparecer
  end
end