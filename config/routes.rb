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
      patch 'add_to_survey'
      post 'import'
    end
  end

  resources :users do
    collection do
      patch 'destroy_selected'
    end
  end

  resources :surveys, except: [:show, :edit, :create, :update] do
    member do
      patch 'update_employees'
      get 'preview'
    end
  end

  namespace :surveys do
    resources :web_surveys, as: 'company_surveys', except: :index
    resources :email_surveys, except: [:index, :destroy] do
      member do
        get 'preview_email'
        get 'comments'
      end
    end
  end

  namespace :admin do
    resources :articles, only: [:index, :edit, :update]
    resources :offered_questions
    resources :offered_surveys
  end

  mount Resque::Server, at: '/background'

  # route for handling email links
  get 'results' => 'results#add_result'
  patch 'comment/:id' => 'results#add_comment', as: 'answer_comment'
  get 'thanks_for_comment' => 'results#thanks_for_comment'

  get 'contact' => 'contacts#new', as: :new_contact
  post 'contact' => 'contacts#create', as: :contacts

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
