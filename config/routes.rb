Rails.application.routes.draw do
  root 'static#index'
  get 'static/index'

  resources :foods, only: [:search, :new] do
    collection do
      post 'search'
    end
  end
end
