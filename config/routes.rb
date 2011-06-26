Minefold::Application.routes.draw do
  root :to => 'home#index'

  # Signup
  get  '/signup' => 'user#new', :as => :new_user
  post '/signup' => 'user#create', :as => :users

  # Auth
  get  '/signin' => 'devise/sessions#new', :as => :new_session
  post '/signin' => 'devise/sessions#create'
  get  '/signout' => 'devise/sessions#destroy', :as => :destroy_session

  # Players
  get  '/:username' => 'user#show'
  get  '/:username/:world' => 'world#show'

  # Worlds
  # TODO: Private worlds
  resources :worlds

  # TODO: Devise is the anti-christ. It is initialized from here…
  devise_for :users
end
