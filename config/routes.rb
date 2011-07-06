Minefold::Application.routes.draw do

  root to: 'users#dashboard',
       constraints: ->(req){ req.env['warden'].authenticated? },
       as: :dashboard

  root :to => 'home#teaser'


  # Signup
  get  '/sign_up' => 'users#new'
  post '/sign_up' => 'users#create', :as => :users


  # Authentication
  get    '/sign_in'  => 'sessions#new',  :as => :new_session
  post   '/sign_in'  => 'sessions#create',  :as => :sessions
  delete '/sign_out' => 'sessions#destroy', :as => :session


  # Payment
  # post '/purchase' => 'orders#create'
  #
  # get '/order/:id' => 'orders#show'
  # put '/order/:id' => 'order#update'


  # Players
  get  '/player/:username' => 'user#show'


  # Worlds
  get '/:slug' => 'worlds#show'


  # Playground
  get '/the-shaft' => 'worlds#show'
end
