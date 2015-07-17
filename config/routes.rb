Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users

  root 'companies#show'

  resources :companies, only: [:show, :edit, :update]
  resources :employees, except: [:index]
end
