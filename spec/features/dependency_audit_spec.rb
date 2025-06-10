# spec/features/dependency_audit_spec.rb

require 'rails_helper'

# ¡YA NO NECESITAMOS NINGÚN REQUIRE DE BUNDLER-AUDIT!

RSpec.feature "Dependency Audit Page", type: :feature do
  let(:user) { create(:user) }
  
  before do
    login_as(user, scope: :user)
  end

  scenario "User visits the dependency audit page and sees no vulnerabilities" do
    # El mock del scanner sigue siendo necesario
    allow_any_instance_of(Bundler::Audit::Scanner).to receive(:scan).and_return([])
    visit dashboard_dependency_audit_path

    expect(page).to have_content("Dependency Audit")
    expect(page).to have_content("Congratulations!")
  end

  scenario "User visits the dependency audit page and sees a vulnerability" do
    # --- ASÍ SE CREA UN OBJETO SIMULADO (MOCK) ---
    # 1. Simula el objeto `gem`
    dummy_gem = double('gem', name: 'dummy_gem', version: '1.0.0')
    
    # 2. Simula el objeto `advisory`
    dummy_advisory = double('advisory',
                            title: 'Critical Flaw',
                            url: 'http://example.com/advisory',
                            criticality: :high,
                            patched_versions: ['1.0.1'])
                            
    # 3. Simula el resultado final, que se comporta como un UnpatchedGem
    #    Le enseñamos a responder a los métodos :gem y :advisory
    #    y a `respond_to?(:gem)` para que pase el filtro en la vista.
    vulnerable_result = double('UnpatchedGem',
                               gem: dummy_gem,
                               advisory: dummy_advisory)
    allow(vulnerable_result).to receive(:respond_to?).with(:gem).and_return(true)
    # ---------------------------------------------------
    
    # El mock del scanner ahora devuelve nuestro objeto simulado
    allow_any_instance_of(Bundler::Audit::Scanner).to receive(:scan).and_return([vulnerable_result])
    
    visit dashboard_dependency_audit_path
    
    expect(page).to have_content("Warning!")
    
    within('table') do
      expect(page).to have_content("dummy_gem")
      expect(page).to have_content("1.0.0")
      expect(page).to have_content("Critical Flaw")
      expect(page).to have_content("High")
      expect(page).to have_content("Upgrade to version 1.0.1")
    end
  end
end