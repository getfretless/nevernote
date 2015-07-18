Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  root 'welcome#index'
  get 'sign_up' => 'users#new'
  resources :users, only: [:create, :edit, :update]

  resources :sessions, only: :create
  delete 'logout' => 'sessions#destroy'
  get    'login'  => 'sessions#new'

  resources :notes, except: :edit

  namespace :api do
    namespace :v1 do
      resources :notes, except: [:new, :edit]
    end
  end
end
