Rails.application.routes.draw do

  get 'home/index'

  get 'home/about_us'

  ActiveAdmin.routes(self)
  devise_for :users

  root 'companies#show'

  resources :companies, only: [:show, :edit, :update]

  resources :employees do
    collection do
      patch 'add_to_survey'
      post 'import'
    end
  end

  resources :surveys do
    member do
      get 'preview'
      patch 'update_employees'
    end
  end

  get 'dashboard' => 'dashboard#index'
  mount Resque::Server, at: '/resque'

  # route for handling email links
  get 'answers' => 'answers#add_answer'

  get 'about' => 'home#about_us'
end
