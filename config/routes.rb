Rails.application.routes.draw do
  root to: 'dashboard#index'

  namespace :admin do
    resources :companies
  end
end
