require 'rails_helper'

RSpec.feature "ContentSecurityPolicy", type: :feature do
  let(:user) { create(:user) }
  # Usamos un post con un script que debería ser bloqueado por la CSP
  let!(:post_with_script) { create(:post, content: "<script>alert('CSP FAILED')</script>", user: user) }

  before do
    login_as(user, scope: :user)
    # NOTA: Para este test, necesitamos que la vista renderice el HTML en crudo
    # para que el navegador intente ejecutar el script y la CSP actúe.
    # Nos aseguramos de que ApplicationController permita esto temporalmente
    # para poder probar la CSP de forma aislada.
    allow_any_instance_of(PostsController).to receive(:show) do |controller|
      @post = post_with_script
      # Renderiza la vista 'show' saltándose el renderizado por defecto para usar `raw`
      controller.instance_variable_set(:@post, @post)
      controller.render :show
    end

    # Modificamos la vista en memoria para usar `raw` y así probar la CSP.
    # Esto evita tener que modificar el fichero físico.
    original_show = File.read(Rails.root.join("app/views/posts/show.html.erb"))
    vulnerable_show = original_show.gsub('<%= @post.content %>', '<%= raw @post.content %>')
    allow(File).to receive(:read).and_call_original
    allow(File).to receive(:read).with(Rails.root.join("app/views/posts/show.html.erb")).and_return(vulnerable_show)
  end

  it "sends a restrictive Content Security Policy header" do
    visit post_path(post_with_script)

    csp_header = page.response_headers['Content-Security-Policy']
    expect(csp_header).not_to be_nil

    script_src_directive = csp_header.split(';').find { |dir| dir.strip.start_with?('script-src') }
    expect(script_src_directive).not_to include("'unsafe-inline'")

    expect(script_src_directive).to include("sha256-DpVt+Ev/lTHBvE9AP6MusgWkuqGvLlkqNGv2dwHVOyE=")
    expect(script_src_directive).to include("sha256-Bk2Ki1XPeMQgcV8U6q5OUXYdrX/47R4L1F0tatGpT7w=")

    expect(csp_header).not_to include("style-src 'unsafe-inline'")
  end
end