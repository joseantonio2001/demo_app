require 'rails_helper'

RSpec.feature "IDOR Protection", type: :feature do

  # Escenario: Un usuario intenta editar el post de otro usuario
  scenario "user cannot edit another user's post" do
    # 1. SETUP: Creamos los dos usuarios y el post del propietario
    user_owner = create(:user, email: 'owner@example.com')
    user_attacker = create(:user, email: 'attacker@example.com')
    post_to_attack = create(:post, title: "Owner's Post", content: "This is a private post.", user: user_owner)

    # 2. LOGIN: El atacante inicia sesión
    login_as(user_attacker, scope: :user)

    # 3. ATTACK (EDIT): El atacante intenta visitar la página de edición del post ajeno
    visit edit_post_path(post_to_attack)

    # 4. VERIFICATION (ASSERTION): Verificamos que la protección ha funcionado
    expect(current_path).to eq(root_path)

    # También verificamos que se muestra un mensaje de error de autorización.
    expect(page).to have_content("You are not authorized to perform this action.")
    
    # Adicionalmente, podemos verificar que la página de edición NO se ha mostrado
    expect(page).not_to have_content("Edit Post")
    expect(page).not_to have_content("Owner's Post")
  end
end