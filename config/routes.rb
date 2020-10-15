Rails.application.routes.draw do
  root to: "home#show"

  resources :categories, only: :show

  get :month, to: "months#show"
end
