
Rails.application.routes.draw do
  resources :posts
  devise_for :users
  root 'home#index'
  
  get 'dashboard', to: 'dashboard#index'
  get 'dashboard/dependency_audit', to: 'dashboard#dependency_audit'
  get 'dashboard/security_logs', to: 'dashboard#security_logs', as: 'security_logs_dashboard'

  get '*path', to: redirect('/'), constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }  
end