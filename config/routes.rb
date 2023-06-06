
Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations' }
  root 'home#index'
  post '/upload_image', to: 'home#upload_image', as: 'upload_image'
  
  resources :classrooms
end

