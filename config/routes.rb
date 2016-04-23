Rails.application.routes.draw do
  root 'teams#new'

  resources :teams, only: [:new, :create] do
  	collection do
  		post 'join'
  	end
  	resources :users, only: [:new, :create, :edit, :update]
    resources :channels, only: [:new, :create]
  end

  get 'msgs/:type/:id/:filter', to: 'msgs#index'
  post 'msgs', to: 'msgs#create'
  delete 'msgs/:id', to: 'msgs#destroy'

  resources :invitations, only: [:new, :create]

  post 'login', to: 'sessions#create'
  get 'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'

  get 'password_reset', to: 'password_reset#new'
  post 'password_reset', to: 'password_reset#create'
  get 'password_reset/:password_reset_token', to: 'password_reset#edit', as: 'edit_password_reset'
  patch 'password_reset/:password_reset_token', to: 'password_reset#update', as: 'update_password_reset'

end
