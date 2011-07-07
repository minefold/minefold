Minefold::Application.routes.draw do

  root to: 'users#dashboard',
       constraints: ->(req){ req.env['warden'].authenticated? },
       as: :dashboard

  root :to => 'home#teaser'


  # Signup
  get  '/sign_up' => 'users#new'
  post '/sign_up' => 'users#create', :as => :users


  # Worlds
  resources :worlds, :only => [:new, :create] do
    post 'activate', :on => :member
  end

  # Authentication
  get    '/sign_in'  => 'sessions#new',  :as => :new_session
  post   '/sign_in'  => 'sessions#create',  :as => :sessions
  get    '/sign_out' => 'sessions#destroy', :as => :session


  get '/unauthorized' => 'sessions#unauthorized'

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
