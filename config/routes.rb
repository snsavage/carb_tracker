Rails.application.routes.draw do
  resources :foods

  root 'static#index'

  get 'static/index'

end
