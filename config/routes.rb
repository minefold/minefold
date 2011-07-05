Minefold::Application.routes.draw do

  root to: 'user#dashboard',
       constraints: ->(req){ req.env['warden'].authenticated? },
       as: :dashboard

  root :to => 'home#teaser'

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

  # Authentication
  get    '/sign_in'  => 'sessions#new'
  post   '/sign_in'  => 'sessions#create'
  delete '/sign_out' => 'sessions#destroy'

  # Payment
  post '/purchase' => 'orders#create'

  get '/order/:id' => 'orders#show'
  put '/order/:id' => 'order#update'

end
