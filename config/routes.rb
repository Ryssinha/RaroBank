require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations' }
  root 'home#index'
  post '/upload_image', to: 'home#upload_image', as: 'upload_image'
  
  resources :classrooms

  resources :balances, only: [:show] do
    member do
      post 'deposit'
      post 'withdraw'
    end
  end

  resources :transfers, only: [:show, :new, :create] do
    get :confirmation, on: :collection
  end


  resources :users do
    resource :balance, only: [:show] do
      post :deposit
      post :withdraw
    end
  end


  resources :administrators, only: [:index] do
    collection do
      post :deposit_all
    end
  end

  post '/administrators/deposit', to: 'administrators#deposit', as: :deposit_administrators
  
  resources :investments do
  end
  
  mount Sidekiq::Web => '/jobs'
end

