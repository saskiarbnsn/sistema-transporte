Rails.application.routes.draw do
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}

  root "homes#index"

  resources :fields
  resources :customers
  resources :trucks
  resources :drivers
  resources :destinations
end
