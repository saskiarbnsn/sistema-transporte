Rails.application.routes.draw do
  devise_for :users,
    path_names: { sign_in: "login", sign_out: "logout" },
    controllers: { registrations: "users/registrations" }

  post "notifications/dismiss", to: "application#dismiss_notifications"

  root "homes#index"

  resources :fields
  resources :customers
  resources :trucks
  resources :drivers
  resources :destinations
  resources :gastos

  resources :trips, only: %i[index show new create edit update] do
    patch :update_status, on: :member
  end
end
