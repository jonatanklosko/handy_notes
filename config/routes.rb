Rails.application.routes.draw do
  root 'pages#home'
  
  get 'signup' => 'users#new'
  post 'signup' => 'users#create'
end
