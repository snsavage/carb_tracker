Rails.application.routes.draw do
  root 'static#index'
  get 'static/index'

  post 'foods/search', to: 'foods#search'

  resources :recipes
end
