require 'rails_helper'

RSpec.feature "Password Recovery", type: :feature do
    let!(:user) { User.create!(
        email: "recover@example.com", 
        password: "OldPassword123!", 
        username: "recover_user"
    ) }

    scenario "User can recover their password" do
        # 1. Solicitar el reseteo de contraseña
        visit new_user_password_path
        fill_in "Email", with: user.email
        click_button "Send me reset password instructions"

        # 2. Verificar que el correo se ha enviado
        expect(page).to have_content("You will receive an email with instructions on how to reset your password in a few minutes.")
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        
        # 3. Extraer el token del correo
        mail = ActionMailer::Base.deliveries.last
        token = mail.body.encoded.match(/reset_password_token=([^"]+)/)[1]

        # 4. Visitar el enlace y establecer una nueva contraseña
        visit edit_user_password_path(reset_password_token: token)
        
        fill_in "New password", with: "NewSecurePassword456!"
        fill_in "Confirm new password", with: "NewSecurePassword456!"
        click_button "Change my password"

        # 5. Verificar que la contraseña se cambió con éxito
        expect(page).to have_content("Your password has been changed successfully.")
        expect(page).to have_content("You are now signed in.")

        # 6. Cerrar sesión e iniciar sesión con la nueva contraseña
        find('a.dropdown-toggle', text: user.email).click
        click_button "Sign Out"

        visit new_user_session_path
        fill_in "Email", with: user.email
        fill_in "Password", with: "NewSecurePassword456!"
        click_button "Log in"
        
        expect(page).to have_content("Signed in successfully.")
    end
end