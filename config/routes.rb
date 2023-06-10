Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations' }
  root 'administrators#dashboard', as: 'administrator_dashboard', constraints: ->(request) { request.env['warden'].user&.administrator? }

  # Rotas públicas acessíveis a todos os usuários
  resources :classrooms, only: [:index, :show]

  # Rotas protegidas pelo escopo de autenticação do administrador
  authenticate :user, ->(user) { user.administrator? } do
    resources :administrators, only: [:index] do
      collection do
        post :deposit_all
      end
    end
    resources :classrooms
    root 'administrators#index', constraints: ->(request) { request.env['warden'].user&.administrator? }
    post '/administrators/deposit', to: 'administrators#deposit', as: :deposit_administrators
    get '/classroom_management', to: 'administrators#classroom_management', as: 'classroom_management'
    get '/administrator/dashboard', to: 'administrators#dashboard', as: 'admin_dashboard'
  end

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
    resource :extract, only: [:show]
  end
end
