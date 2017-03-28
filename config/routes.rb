Rails.application.routes.draw do
  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  unauthenticated do
    root to: 'static#index'
  end

  authenticated do
    root to: 'logs#index'
  end

  resources :static, only: [:index]
  resources :recipes

  resources :foods do
    get 'desc', on: :collection
  end

  resources :users, only: [] do
    resources :logs do
      get 'today', on: :collection
    end
  end
end
