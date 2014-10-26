Passmein::Application.routes.draw do
  root 'home#home'

  resource :users, only: [:create, :update]
  post 'login', to: 'users#login'
  post 'logout', to: 'users#logout'

  resources :details, only: [:index, :create, :update, :destroy]
end
