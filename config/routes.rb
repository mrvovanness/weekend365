Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :users

  root 'home#index'

  resources :companies, only: [:show, :edit, :update]

  resources :employees do
    collection do
      patch 'add_to_survey'
      post 'import'
    end
  end

  get 'surveys' => 'surveys/pulses#index'
  namespace :surveys do
    resources :pulses, except: :index do
      member do
        get 'preview'
        patch 'update_employees'
      end
    end
  end

  get 'dashboard' => 'dashboard#index'
  get 'about' => 'pages#about'
  mount Resque::Server, at: '/background'

  # route for handling email links
  get 'results' => 'results#add_result'
end
