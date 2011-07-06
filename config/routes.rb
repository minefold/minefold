Minefold::Application.routes.draw do

  root to: 'users#dashboard',
       constraints: ->(req){ req.env['warden'].authenticated? },
       as: :dashboard

  root :to => 'home#teaser'

  # Signup
  get  '/sign_up' => 'users#new'
  post '/sign_up' => 'users#create', :as => :users

  # Players
  # get  '/:username' => 'user#show'
  # get  '/:username/:world' => 'world#show'

  # Worlds
  resources :worlds, :only => [:new, :create] do
    post 'activate', :on => :member
  end

  # Authentication
  get    '/sign_in'  => 'sessions#new'
  post   '/sign_in'  => 'sessions#create', :as => :new_session
  get    '/sign_out' => 'sessions#destroy'
  delete '/sign_out' => 'sessions#destroy'

  # Payment
  post '/purchase' => 'orders#create'

  get '/order/:id' => 'orders#show'
  put '/order/:id' => 'order#update'
  
  # world
  get '/:slug' => 'worlds#show'
end
