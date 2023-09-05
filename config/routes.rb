Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :properties, only: %i[index new create edit update destroy] do
    resources :jobs, only: %i[index show new create]
    resources :employees, only: %i[create destroy]
  end

  resources :jobs, only: %i[index show] do
    resources :japplications, only: %i[create update]
    resources :reviews, only: %i[create]
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
