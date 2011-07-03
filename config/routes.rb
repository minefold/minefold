Minefold::Application.routes.draw do

  # root to: 'user#dashboard',
  #      constraints: ->(req){ req.env['warden'].authenticated? },
  #      as: :dashboard

  root :to => 'home#public'

  # Signup
  get  '/signup' => 'user#new', :as => :user
  post '/signup' => 'user#create', :as => :users

  # Players
  # get  '/:username' => 'user#show'
  # get  '/:username/:world' => 'world#show'

  # Worlds
  resources :worlds do
    post 'activate', :on => :member
  end

  # devise_for :user do
  #   get  '/signin' => 'devise/sessions#new'
  #   post '/signin' => 'devise/sessions#create'
  #   get  '/signout' => 'devise/sessions#destroy'
  # end
end
