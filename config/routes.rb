Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#index'

  resources :employees

  namespace :admin do
    resources :companies
  end
end
