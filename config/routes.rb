# Only use hash rockets here please.

Minefold::Application.routes.draw do
  root :to => 'pages#home'
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
  devise_for :users, :skip => [:sessions, :passwords, :registrations] do
    get    '/signin' => 'sessions#new', :as => :new_user_session
    post   '/signin' => 'sessions#create', :as => :user_session
    delete '/signout' => 'sessions#destroy', :as => :destroy_user_session

    get '/account/amnesia' => 'passwords#new', :as => :new_user_password
    post '/account/amnesia' => 'passwords#create'
    get '/account/revive' => 'passwords#edit', :as => :edit_user_password
    put '/account/revive' => 'passwords#update'

    get  '/signup/check' => 'users#check'
    get  '/signup' => 'users#new', :as => :new_user
    post '/users' => 'users#create', :as => :users
  end

  controller :stripe, :path => :customer, :as => :customer do
    get :new
    put :create
  end

  resource :account, :only => [:edit, :update], :path_names => {:edit => '/'} do
    get :time
    get :notifications
  end

  resource :order, :only => [:create]

  post '/stripe/webhook' => 'stripe#webhook'

  as :user do
    resources :users, :path => 'players', :only => [:show]
  end
  
  resources :worlds, :only => [:new, :create, :index] do
    collection do
      resource :upload, :module => :worlds, :only => [:new, :create] do
        get :policy
      end
    end
  end
  
  scope '/:user_id', :as => :user do
    resources :worlds, :path => '/', :only => [:show, :edit, :update, :destroy], :path_names => {:edit => 'settings'} do

      member do
        get :info
        put :play
      end

      scope :module => :worlds do
        resources :events, :only => [:index, :create]
        resources :members, :controller => :memberships, :only => [:index, :create, :destroy] do
          get  :search, :action => :search, :on => :collection
        end

        resources :membership_requests do
          put :approve
        end

        resources :photos
      end
    end
  end

  namespace :api do
    resources :sessions, :only => [:create]
    resources :photos, :only => [:create]
  end

end
