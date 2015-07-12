Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users

  root 'companies#show'

  resources :employees
  resources :companies, only: [:show, :edit, :update]
end
