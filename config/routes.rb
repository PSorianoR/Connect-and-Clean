Rails.application.routes.draw do
  get 'teams/create'
  get 'teams/destroy'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :properties do
    resources :jobs, only: %i[index show new create]
    resources :teams, only: %i[create destroy]
  end

  resources :jobs, only: %i[index show] do
    resources :job_applications, only: %i[create update]
    resources :reviews, only: %i[create new]
  end

  resources :users, only: %i[show]

  get 'dashboard', to: "users#dashboard", as: "dashboard"
  post 'mode', to: "users#mode", as: "mode"

  # Defines the root path route ("/")
  # root "articles#index"
end
