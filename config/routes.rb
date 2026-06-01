Rails.application.routes.draw do
  devise_for :users, path_names: { sign_in: "login", sign_out: "logout" }

  root "homes#index"

  resources :fields
  resources :customers
  resources :trucks
  resources :drivers
  resources :destinations
  resources :trips, only: %i[index show new create edit update] do
    patch :update_status, on: :member
  end
end
