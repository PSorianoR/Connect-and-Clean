Rails.application.routes.draw do
  get 'message/create'
  get 'chatroom_member/create'
  get 'chatroom/index'
  get 'chatroom/show'
  get 'chatroom/create'
  get 'teams/create'
  get 'teams/destroy'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :properties do
    resources :jobs, only: %i[index show create]
    resources :teams, only: %i[create destroy]
  end

  resources :jobs, only: %i[index show new] do
    resources :job_applications, only: %i[create update]
    resources :reviews, only: %i[create new]
  end

  resources :users, only: %i[show]

  resources :chatrooms, only: %i[index show create] do
    resources :chatroom_members, only: %i[create]
    resources :messages, only: %i[create] do
      resources :job_messages, only: %i[create]
    end
  end

  get 'dashboard', to: "users#dashboard", as: "dashboard"
  post 'mode', to: "users#mode", as: "mode"

  # Defines the root path route ("/")
  # root "articles#index"
end
