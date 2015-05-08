Rails.application.routes.draw do
  root to: 'dashboard#index'

  resources :employees

  namespace :admin do
    resources :companies
  end
end
