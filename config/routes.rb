Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "lots#lista_users_teste"
  resources :items
  resources :users
  resources :categories
  
  resources :lots do 
    resources :items_lots
  end
  
end
