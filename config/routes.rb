Rails.application.routes.draw do
  resources :messages, only: [:create, :show]
end
