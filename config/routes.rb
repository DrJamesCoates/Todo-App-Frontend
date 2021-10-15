Rails.application.routes.draw do

  root 'static_pages#home'
  get '/contact', to: 'static_pages#contact'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get '/signup', to: 'users#new'
  resources :users, only: [:update, :edit, :create, :delete, :show]

  resources :todos
end
