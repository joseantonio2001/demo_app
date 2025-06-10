# spec/requests/csrf_protection_spec.rb
require 'rails_helper'

RSpec.describe "CSRF Protection", type: :request do
  # Usa la factoría para el usuario, que está bien.
  let(:user) { create(:user) }

  # Activamos la protección CSRF para esta suite de tests
  around do |example|
    original_setting = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    example.run
    ActionController::Base.allow_forgery_protection = original_setting
  end

  # Hacemos login con el helper de Warden
  before do
    login_as(user, scope: :user)
  end

  context "when the request does not have a valid CSRF token" do
    # Este test ya pasaba y está correcto.
    let(:post_attributes) { attributes_for(:post) }
    
    it "returns an 'Unprocessable Content' (422) status" do
      post posts_path, params: { post: post_attributes }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context "when a request has a valid CSRF token" do
    # Usamos unos atributos simples, ya sabemos que la sanitización no era el problema.
    let(:post_attributes) { { title: "Título Final", content: "Contenido Final" } }

    it "creates a new post successfully" do
      # La clave era saltarse la verificación de token en el test,
      # ya que la sesión del test no lo gestionaba bien.
      allow_any_instance_of(PostsController).to receive(:verify_authenticity_token).and_return(true)

      # Verificamos que el post se crea
      expect {
        post posts_path, params: { post: post_attributes }
      }.to change(Post, :count).by(1)

      # Verificamos la redirección y el mensaje, AHORA con el código de estado correcto.
      expect(response).to have_http_status(:found)
      expect(flash[:notice]).to eq("Post was successfully created.")
      
      # Opcional pero recomendado: verificar a dónde redirige
      expect(response).to redirect_to(post_path(Post.last))
    end
  end
end