Rails.application.routes.draw do
  devise_for :users

  root to: 'dashboard#index'

  resources :employees

  namespace :admin do
    resources :companies
  end
end
