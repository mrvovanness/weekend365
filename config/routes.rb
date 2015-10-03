Rails.application.routes.draw do

  get 'signup' => 'signups#new', as: :new_signup
  post 'signup' => 'signups#create', as: :signups
  as :user do
    patch '/user/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
  end
  devise_for :users, :controllers => { :confirmations => "confirmations" }, skip: [:registrations]

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

  get 'contact' => 'contacts#new', as: :new_contact
  post 'contact' => 'contacts#create', as: :contacts

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
