Rails.application.routes.draw do
  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get 'static/index'

  unauthenticated do
    root to: 'static#index'
  end

  authenticated do
    root to: 'logs#index'
  end

  resources :recipes
  resources :foods

  resources :users, only: [] do
    resources :logs do
      get 'today', on: :collection
    end
  end
end
