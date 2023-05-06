Rails.application.routes.draw do
  # get 'movies/index'
  # get 'movies/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'

  get '/register', to: 'users#new'
  resources :users, only: %i[index new create] do
    resources :discover, only: %i[index]
    resources :movies, only: %i[index show] do
      resources :parties, only: %i[new create]
    end
  end

  get '/dashboard', to: 'users#dashboard'
  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login'

end
