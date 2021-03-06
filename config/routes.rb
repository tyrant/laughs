Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions', registrations: 'registrations', passwords: 'passwords' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'
  resources :venues, only: [:index, :show]
  resources :alerts, only: [:index, :create, :destroy]
end
