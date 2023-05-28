# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  resources :users
  get 'selic', to: 'selic#index'
  
end
