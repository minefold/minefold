Minefold::Application.routes.draw do
  root :to => 'home#index'

  # Admin
  namespace :admin do
    mount Resque::Server => 'resque'

    namespace :mail do
      mount OrderMailer::Preview => 'order'
      mount UserMailer::Preview => 'user'
      mount WorldMailer::Preview => 'world'
    end
  end

  # Static Pages
  {
    '/about'   => 'about',
    '/jobs' => 'jobs',
    '/contact' => 'contact',
    '/help'    => 'help',
    '/privacy' => 'privacy',
    '/terms'   => 'terms'
  }.each do |url, name|
    get url => 'high_voltage/pages#show', :id => name, :as => "#{name}_page"
  end


  # Authentication
  devise_for :users, :skip => [:sessions, :registrations, :passwords] do

    # # Sessions
    get    '/sign-in' => 'devise/sessions#new', :as => :new_user_session
    post   '/sign-in' => 'devise/sessions#create', :as => :user_session
    delete '/sign-out' => 'devise/sessions#destroy', :as => :destroy_user_session

    # Registrations
    get  '/sign-up' => 'users#new', :as => :new_user
    get  '/sign-me-up-scotty' => 'users#new', :secret => 'fe0e675728078c78912cd5a9779f0217e3c90f6ec9bc9d89240cf4236145a7429e257a8c7dcae8f0267944bbc1ca9adb5519706e01d3d9aadcc46b727df34567'
    post '/sign-up' => 'users#create', :as => :users
  end


  devise_scope(:user) do

    # Dashboard
    get  '/dashboard' => 'users#dashboard', :as => :user_root

    # Payment
    get  '/buy' => 'orders#new', :as => :new_order
    post '/order' => 'orders#create', :as => :order
    get  '/order/success' => 'orders#success', :as => :successful_order
    get  '/order/cancel' => 'orders#cancel', :as => :cancel_order

    # Referrals
    # get  '/referrals' => 'referrals#new', :as => :new_referral
    # post '/referrals' => 'referrals#create', :as => :referrals

    # Worlds
    # get '/explore' => 'worlds#index', :as => :worlds

    scope '/world/:id' do
      get '/' => 'worlds#show', :as => :world
      get '/settings' => 'worlds#edit', :as => :edit_world
      put '/' => 'worlds#update'
      get '/map' => 'worlds#map', :as => :map_world
      get '/photos' => 'worlds#photos', :as => :photos_world
      put '/play' => 'worlds#play', :as => :play_world
      put '/play/request' => 'worlds#play_request', :as => :play_request_world

      resources :wall_items, :only => [:index, :create]
    end

    get '/users/search.json' => 'users#search', :as => :search_user, :format => :json

    # Account
    get '/:id/account' => 'users#edit', :as => :edit_user
    put '/:id' => 'users#update', :as => :user
    get '/:id' => 'users#show', :as => :user
  end

  resources :worlds, :only => [:new, :create] do
    collection do
      get 'upload' => 'worlds#upload'
      get 'upload_policy' => 'worlds#upload_policy'
      post 'process_upload' => 'worlds#process_upload'
    end

    resources :world_photos, :as => :photos, :only => [:create, :destroy]
  end


  # scope '/:creator_id/:id' do
  #   controller :worlds do
  #     get :map, :as => :map_world
  #     get :photos, :as => :photos_world
  #     get :edit, :as => :edit_world
  #
  #     post :follow, :as => :follow_world
  #     post :join, :as => :join_world
  #   end
  #
  #   resources :wall_items, :only => [:index, :create]
  #
  #   get '/' => 'worlds#show', :as => :world
  #   # get '/wall/page/:page' => 'wall_items#show', :as => :world_wall_items
  # end
  #
  # namespace :users do
  #
  #
  #
  # end


  # get '/:id' do
  #
  # end

  # resources :worlds, :except => [:index, :show, :destroy] do

  #   resources :wall_items, :only => [:index, :create] do
  #     get 'page/:page' => 'wall_items#page', :on => :collection
  #   end
  #
  #   collection do
  #     post :import
  #     get :import_policy, :format => :xml
  #   end
  #
  #   member do
  #     post :activate
  #     get  :map
  #     get  :photos
  #   end
  # end

  # mount Resque::Server, :at => '/resque'

  # get '/admin' => 'admin#index', :as => :admin
  # get '/admin/users' => 'admin#users', :as => :admin_users
  # get '/admin/worlds' => 'admin#worlds', :as => :admin_worlds

end
