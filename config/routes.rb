Rails.application.routes.draw do
  get 'signup' => 'signups#new', as: :new_signup
  post 'signup' => 'signups#create', as: :signups
  as :user do
    patch '/user/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
  end
  devise_for :users, :controllers => { :confirmations => "confirmations" }, skip: [:registrations]

  root 'home#index'

  resources :companies
  resources :dashboard, only: :show
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
      get 'email_preview'
    end
  end

  namespace :surveys do
    resources :web_surveys, only: [:new, :create, :edit, :update] do
      member do
        get 'preview'
      end
    end

    resources :email_surveys, only: [:new, :create, :edit, :update] do
      member do
        get 'preview'
        get 'comments'
      end
    end
  end

  namespace :admin do
    resources :articles, only: [:index, :edit, :update]
    resources :offered_questions do
      collection do
        post 'import'
      end
    end
    resources :offered_surveys
  end

  # Pages for answer web survey
  get 'company_surveys/:company_survey_id/:token/:employee_id/take' => 'results#new', as: 'new_result'
  post 'results' => 'results#create'

  # Pages for answer email survey
  get 'results' => 'results#add_result'
  patch 'comment/:id' => 'results#add_comment', as: 'answer_comment'
  get 'thanks_for_comment' => 'results#thanks_for_comment'
  get 'contact' => 'contacts#new', as: :new_contact
  post 'contact' => 'contacts#create', as: :contacts

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

  mount Resque::Server, at: '/background'
end
