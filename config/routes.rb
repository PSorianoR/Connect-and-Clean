Rails.application.routes.draw do
  get 'teams/create'
  get 'teams/destroy'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :properties, only: %i[index new create edit update destroy] do
    resources :jobs, only: %i[index show new create]
    resources :employees, only: %i[create destroy]
  end

  resources :jobs, only: %i[index show] do
    resources :job_applications, only: %i[create update]
    resources :reviews, only: %i[create]
  end

  resources :users, only: %i[show]

  get 'dashboard', to: "users#dashboard", as: "dashboard"
  # Defines the root path route ("/")
  # root "articles#index"
end
