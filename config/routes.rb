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
    get  '/worlds/new' => 'worlds#new',
                   :as => :new_world
    post '/worlds' => 'worlds#create',
               :as => :user_worlds
    get  '/worlds/upload' => 'worlds#upload',
                      :as => :upload_worlds
    get  '/worlds/upload_policy' => 'worlds#upload_policy',
                             :as => :upload_policy_worlds
    post '/worlds/process_upload' => 'worlds#process_upload',
                              :as => :process_upload_worlds

    # Users
    get '/users/search.json' => 'users#search',
                         :as => :search_user,
                     :format => :json
    get '/:id/account' => 'users#edit', :as => :edit_user

    scope '/:user_id/:id' do
      get '/' => 'worlds#show', :as => :user_world
      get '/settings' => 'worlds#edit', :as => :edit_user_world
      put '/' => 'worlds#update'
      get '/map' => 'worlds#map', :as => :map_user_world

      put '/play' => 'worlds#play', :as => :play_user_world
      put '/play/request' => 'worlds#play_request', :as => :play_request_user_world

      controller :wall_items do
        get  '/wall', :action => 'index', :as => :user_world_wall_items
        post '/wall', :action => 'create'
      end

      controller :photos do
        get  '/photos', :action => :index, :as => :photos_user_world
        post '/photos', :action => :create
      end
    end

    # Account
    put '/:id' => 'users#update', :as => :user
    get '/:id' => 'users#show', :as => :user
  end

end
