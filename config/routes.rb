
Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations' }
  root 'home#index'

  resources :classrooms

  resources :balances, only: [:show] do
    member do
      post 'deposit'
      post 'withdraw'
    end
  end
end

