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
  resources :pages, only: :show

  resources :employees do
    collection do
      patch 'destroy_selected'
      post 'import'
    end
  end

  get 'surveys' => 'surveys#index'
  get 'surveys/new' => 'surveys#new', as: :new_survey
  namespace :surveys do
    resources :pulses, except: :index do
      member do
        get 'preview'
        get 'preview_email'
        get 'comments'
        patch 'update_employees'
      end
    end
  end

  namespace :admin do
    resources :articles, only: [:index, :edit, :update]
  end

  mount Resque::Server, at: '/background'

  # route for handling email links
  get 'results' => 'results#add_result'
  patch 'comment/:id' => 'results#add_comment', as: 'answer_comment'

  get 'contact' => 'contacts#new', as: :new_contact
  post 'contact' => 'contacts#create', as: :contacts

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
