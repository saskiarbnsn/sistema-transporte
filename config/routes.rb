Rails.application.routes.draw do
  devise_for :users,
    path_names: { sign_in: "login", sign_out: "logout" },
    controllers: { registrations: "users/registrations" }

  root "homes#index"

  resources :fields
  resources :customers
  resources :trucks do
    patch :reset_service, on: :member
    resources :truck_services, only: %i[index show edit update destroy]
  end
  resources :drivers do
    patch :renew_apto,     on: :member
    patch :renew_licencia, on: :member
  end
  resources :destinations
  resources :gastos

  resources :trips, only: %i[index show new create edit update] do
    patch :update_status, on: :member
  end
end
