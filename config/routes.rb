
Rails.application.routes.draw do
  resources :posts
  devise_for :users
  root 'home#index'
  get 'dashboard', to: 'dashboard#index'

  get '*path', to: redirect('/'), constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }  
end