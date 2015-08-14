Rails.application.routes.draw do

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

  resources :surveys

  get 'dashboard' => 'dashboard#index'
  mount Resque::Server, at: '/resque'

  # route for handling email links
  get 'answers' => 'answers#add_answer'
end
