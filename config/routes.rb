# Only use hash rockets here please.

Minefold::Application.routes.draw do
  root :to => 'pages#home'

  namespace :admin do
    mount Resque::Server.new, :at => "/resque"
  end

  namespace :api do
    resource :session, :only => [:show],  :controller => 'session'
    post '/campaign/webhook' => 'campaign#webhook'
    resources :photos, :only => [:index, :create]
    get 'key' => 'Api#key'
  end

  get  '/dashboard' => 'accounts#dashboard', :as => :user_root

  # Static Pages
  { '/about'   => :about,
    '/help'    => :help,
    '/jobs'    => :jobs,
    '/press'   => :press,
    '/pricing' => :pricing,
    '/privacy' => :privacy,
    '/terms'   => :terms
  }.each do |url, name|
    get url, :controller => 'pages',:action => name, :as => "#{name}_page"
  end

  # Authentication
  devise_scope :user do
    get    '/signin' => 'sessions#new', :as => :new_user_session
    post   '/signin' => 'sessions#create', :as => :user_session
    delete '/signout' => 'sessions#destroy', :as => :destroy_user_session

    get '/account/amnesia' => 'passwords#new', :as => :new_user_password
    post '/account/amnesia' => 'passwords#create', :as => nil
    get '/account/revive' => 'passwords#edit', :as => :edit_user_password
    put '/account/revive' => 'passwords#update', :as => nil

    get  '/signup' => 'users#new', :as => :new_user
    post '/users' => 'users#create', :as => :users

    get  '/confirm/new' => 'confirmations#new', :as => :new_user_confirmation
    post '/confirm' => 'confirmations#create', :as => :user_confirmation
    get  '/confirm/:confirmation_token' => 'confirmations#show', :as => :confirmation

    resource :account, :only => [:edit, :update], :path_names => {:edit => '/'} do
      get :pro
      get :notifications
    end
  end

  devise_for :user, :skip => [:sessions, :passwords, :registrations, :confirmations]

  controller :stripe, :path => :customer, :as => :customer do
    get :new
    put :create
  end

  resource :order, :only => [:create]

  post '/stripe/webhook' => 'stripe#webhook'

  resources :worlds, :only => [:new, :create, :index, :destroy] do
    collection do
      resource :upload, :module => :worlds, :only => [:new, :create] do
        get :instructions
        get :policy
      end
    end
  end

  get '/oembed' => 'o_embed#show', :defaults => { :format => 'json' }

  resources :photos do
    get :oembed, :on => :collection
  end


  # get '/shots/:id' => 'shots#show', :id => /[A-Fa-f0-9]{24}\-.*/
  # put '/shots/:id' => 'shots#update', :id => /[A-Fa-f0-9]{24}/
  # delete '/shots/:id' => 'shots#destroy', :id => /[A-Fa-f0-9]{24}/
  #
  # post '/shots/albums' => 'shot_albums#create'
  # delete '/shots/albums/:id' => 'shot_albums#destroy'
  # put '/shots/albums/:id' => 'shot_albums#update'
  #
  # get '/shots/admin' => 'shots#admin'
  # get '/shots/admin/albums/:id' => 'shot_albums#admin'
  #
  # get '/shots' => 'shots#everyone'
  # get '/shots/:user_slug' => 'shots#for_user'
  # get '/shots/:user_slug/:shot_album_slug' => 'shots#for_album'

  get '/lightroom' => 'photos#lightroom', :as => :lightroom

  devise_scope :user do
    resources :users, :path => '/', :only => [:show] do

      scope :module => :users do
        resources :photos
      end

      resources :worlds, :path => '/', :except => [:index], :path_names => {:edit => 'settings'} do
        member do
          put :join
          put :clone
        end

        scope :module => :worlds do
          # resources :events, :only => [:index, :create]
          resources :members, :controller => :memberships, :only => [:index, :create, :destroy] do
            get  :search, :action => :search, :on => :collection
          end

          resources :membership_requests, :only => [:create, :destroy] do
            put :approve, :on => :member
          end
        end
      end


    end
  end
end
