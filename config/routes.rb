Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # wladimir, volta aqui
  # adiciona os onlys
  root "lots#lista_users_teste"
  resources :items
  resources :users
  resources :categories
  
  resources :lots do 
    get 'waiting_approval', on: :collection
    resources :items_lots
    resources :bids
  end
  
end
