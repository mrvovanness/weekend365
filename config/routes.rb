Rails.application.routes.draw do

  get 'signup' => 'signups#new', as: :new_signup
  post 'signup' => 'signups#create', as: :signups
  devise_for :users, skip: [:registrations]

  root 'home#index'

  resources :companies
  resources :dashboard, only: [:index, :show]

  resources :employees do
    collection do
      patch 'destroy_selected'
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

  namespace :admin do
    resources :articles, only: [:index, :edit, :update]
  end

  get 'about' => 'pages#about'
  mount Resque::Server, at: '/background'

  # route for handling email links
  get 'results' => 'results#add_result'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
