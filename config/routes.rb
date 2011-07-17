Minefold::Application.routes.draw do

  resources :s3_uploads

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
  get    '/sign_out' => 'sessions#destroy', :as => :session
  get    '/unauthorized' => 'sessions#unauthorized', :as => :unauthorized

  # Payment
  get  '/credits' => 'orders#new', :as => :credits
  post '/order' => 'orders#create', :as => :order
  get  '/order/success' => 'orders#success', :as => :successful_order
  get  '/order/cancel' => 'orders#cancel', :as => :cancel_order


  # Players
  get  '/player/:username' => 'user#show'

  # Worlds

  resources :world_imports, :only => [:new, :create]

  match "/resque", :to => Resque::Server.new, :anchor => false

  get '/about' => 'high_voltage/pages#show', :id => 'about'

  get  '/worlds/new' => 'worlds#new', :as => :new_world
  post '/worlds' => 'worlds#create', :as => :worlds
  post '/:id/activate' => 'worlds#activate', :as => :activate_world
  post '/:id/post' => 'worlds#post', :as => :post_world
  get  '/:id' => 'worlds#show', :as => :world
end
