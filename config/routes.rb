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
    post '/account/amnesia' => 'passwords#create', :as => nil
    get '/account/revive' => 'passwords#edit', :as => :edit_user_password
    put '/account/revive' => 'passwords#update', :as => nil

    get  '/signup' => 'users#new', :as => :new_user
    post '/users' => 'users#create', :as => :users

    get  '/confirm/new' => 'confirmations#new', :as => :new_user_confirmation
    post '/confirm' => 'confirmations#create', :as => :user_confirmation
    get  '/confirm/:confirmation_token' => 'confirmations#show', :as => :confirmation

    resource :account, :only => [:edit, :update], :path_names => {:edit => '/'} do
      get :time
      get :notifications
    end
  end

  controller :stripe, :path => :customer, :as => :customer do
    get :new
    put :create
  end

  resource :order, :only => [:create]

  post '/stripe/webhook' => 'stripe#webhook'

  namespace :api do
    resource :session, :only => [:show],  :controller => 'session'
    resources :photos, :only => [:create]
  end

  resources :worlds, :only => [:new, :create, :index] do
    collection do
      resource :upload, :module => :worlds, :only => [:new, :create] do
        get :policy
      end
    end
  end

  as :user do
    resources :users, :path => '/', :only => [:show] do
      resources :worlds, :path => '/', :except => [:index], :path_names => {:edit => 'settings'} do
        scope :module => :worlds do
          resources :events, :only => [:index, :create]
          resources :members, :controller => :memberships, :only => [:index, :create, :destroy] do
            get  :search, :action => :search, :on => :collection
          end

          resources :membership_requests, :only => [:create, :destroy] do
            put :approve, :on => :member
          end

        resources :membership_requests do
          put :approve
        end

        member do
          put :join
          post :clone
        end
      end
    end
  end

  namespace :api do
    resource :session, :only => [:show], :controller => 'session'
    resources :photos, :only => [:create]
  end

end
