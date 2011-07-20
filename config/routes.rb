Minefold::Application.routes.draw do

  # TODO: Bug returning from remembered session
  root to: 'users#dashboard',
       constraints: ->(req){ req.env['warden'].authenticated? },
       as: :dashboard

  resources :s3_uploads

  root :to => 'home#teaser'
  post '/subscribe' => 'home#subscribe', :as => :subscribe


  # Authentication
  devise_for :users, :path_names => {
    sign_up: '/sign_up/s3kr1t'
  }


  # Payment
  get  '/credits' => 'orders#new', :as => :credits
  post '/order' => 'orders#create', :as => :order
  get  '/order/success' => 'orders#success', :as => :successful_order
  get  '/order/cancel' => 'orders#cancel', :as => :cancel_order


  # Worlds

  resources :world_imports, :only => [:create]

  match "/resque", :to => Resque::Server.new, :anchor => false

  get '/about' => 'high_voltage/pages#show', :id => 'about'

  get  '/worlds/new' => 'worlds#new', :as => :new_world
  post '/worlds' => 'worlds#create', :as => :worlds
  post '/:id/activate' => 'worlds#activate', :as => :activate_world
  post '/:id/comment' => 'worlds#comment', :as => :comment_world
  get  '/:id' => 'worlds#show', :as => :world
end
