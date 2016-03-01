Rails.application.routes.draw do
  root 'pages#home'
  
  get 'signup' => 'users#new'
  post 'signup' => 'users#create'
  
  get 'signin' => 'sessions#new'
  post 'signin' => 'sessions#create'
  delete 'signout' => 'sessions#destroy'
  
  resources :account_activations, only: [:show]
end
