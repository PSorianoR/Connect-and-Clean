Rails.application.routes.draw do
  get 'dashboard/index'
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
    resources :jobs, only: %i[show]
    resources :teams, only: %i[create destroy]
  end

  resources :jobs, only: %i[index new create edit update] do
    collection do
      get 'open', to: "jobs#open"
      get 'applied', to: "jobs#applied"
      get 'accepted', to: "jobs#accepted"
      get 'completed', to: "jobs#completed"
    end
    resources :job_applications, only: %i[create update]
    resources :reviews, only: %i[create new show]
    get 'accept_cleaner/:id', to: "jobs#accept_cleaner", as: "accept_cleaner"
    get 'show', to: "jobs#show", as: "job"
  end

  resources :users, only: %i[show index]

  resources :chatrooms, only: %i[index show create] do
    resources :chatroom_members, only: %i[create]
    resources :messages, only: %i[create] do
      resources :job_messages, only: %i[create]
    end
  end

  resources :dashboards, only: %i[index]

  post 'mode', to: "users#mode", as: "mode"
  patch 'change_status', to: "jobs#change_status", as: "job_change_status"
  get 'properties/info/:id', to: "properties#info", as: "property_info"


  # Defines the root path route ("/")
  # root "articles#index"
end
