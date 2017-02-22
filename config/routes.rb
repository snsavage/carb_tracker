Rails.application.routes.draw do
  devise_for :users
  root 'static#index'
  get 'static/index'

  post 'foods/search', to: 'foods#search'

  resources :recipes
  resources :users, only: [:show]
  resources :logs, only: [:new, :create, :edit, :update]
end
