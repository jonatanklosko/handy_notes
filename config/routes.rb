Rails.application.routes.draw do
  root 'pages#home'
  
  get 'signup' => 'users#new'
  post 'signup' => 'users#create'
  get 'users/:username' => 'users#show', as: :user
  get 'users/:username/settings' => 'users#edit', as: :user_settings
  patch 'users/:username' => 'users#update', as: :update_user
  
  get 'signin' => 'sessions#new'
  post 'signin' => 'sessions#create'
  delete 'signout' => 'sessions#destroy'
  
  resources :account_activations, only: [:show]
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  scope ':username' do
    resources :notes, param: :slug, except: [:index]
  end
end
