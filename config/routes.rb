Rails.application.routes.draw do
  resources :search, only: [:new, :create]
  root "search#new"
end
