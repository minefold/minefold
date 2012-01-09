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
  devise_for :users, :skip => :all do
    get    '/signin' => 'devise/sessions#new', :as => :new_user_session
    post   '/signin' => 'devise/sessions#create', :as => :user_session
    delete '/signout' => 'devise/sessions#destroy', :as => :destroy_user_session

    get '/reset-password' => 'passwords#new', :as => :new_user_password
    post '/reset-password' => 'passwords#create'
    get '/edit-password' => 'passwords#edit', :as => :edit_user_password
    put '/edit-password' => 'passwords#update'

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
  end

  resource :order, :only => [:create]

  post '/stripe/webhook' => 'stripe#webhook'

  as :user do
    resources :users, :path => 'players', :only => [:show]
  end

  resources :worlds, :except => :destroy, :path_names => {:edit => 'settings'} do
    collection do
      resource :upload, :module => :worlds, :only => [:new, :create] do
        get :policy
      end
    end

    member do
      get :map
      get :invite
      put :play
    end

    scope :module => :worlds do
      resources :events, :only => [:index, :create]
      resources :players, :only => [:index, :create, :destroy] do
        post :ask, :action => :ask, :on => :collection
        post :add, :action => :add, :on => :collection
        get  :search, :action => :search, :on => :collection

        put :approve, :on => :member
      end

      resources :photos
    end
  end
  
  namespace :api do
    resource :session, :only => [:show], :controller => 'session'
    resources :photos, :only => [:create]
  end

end
