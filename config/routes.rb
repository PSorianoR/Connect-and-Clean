Rails.application.routes.draw do
  get 'reviews/create'
  get 'job_applicatiion/create'
  get 'job_applicatiion/update'
  get 'employees/create'
  get 'employees/destroy'
  get 'jobs/index'
  get 'jobs/show'
  get 'jobs/new'
  get 'jobs/create'
  get 'jobs/destroy'
  get 'properties/index'
  get 'properties/new'
  get 'properties/create'
  get 'properties/edit'
  get 'properties/update'
  get 'properties/destroy'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
