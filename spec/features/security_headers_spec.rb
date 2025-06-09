require 'rails_helper'

RSpec.feature "Security Headers", type: :feature do
  scenario "are present on the home page" do
    # Hacemos una petición a la página de inicio
    visit root_path

    # Verificamos que la página se carga correctamente
    expect(page).to have_content('Welcome to Demo App') 

    # Obtenemos las cabeceras de la respuesta
    headers = page.response_headers

    # Hacemos aserciones sobre las cabeceras de seguridad clave
    # gestionadas por el inicializador de secure_headers.
    expect(headers['X-Frame-Options']).to eq('SAMEORIGIN')
    expect(headers['X-Content-Type-Options']).to eq('nosniff')
    expect(headers['X-Xss-Protection']).to eq('1; mode=block')
    expect(headers['Referrer-Policy']).to include('origin-when-cross-origin')
  end
end