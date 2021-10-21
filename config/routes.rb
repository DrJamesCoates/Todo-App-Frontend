Rails.application.routes.draw do
  default_url_options :host => "http://127.0.0.1:4000/"

  root 'static_pages#home'
  get '/contact', to: 'static_pages#contact'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  get '/signup', to: 'users#new'
  resources :users, only: [:update, :edit, :create, :destroy, :show]

  resources :todos do
    resources :items, only: [:new, :create, :edit, :update, :destroy]
  end
end
