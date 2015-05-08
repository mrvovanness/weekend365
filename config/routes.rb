Rails.application.routes.draw do
  root to: 'pages#index'

  namespace :admin do
    resources :companies
  end
end
