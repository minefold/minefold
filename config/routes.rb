Minefold::Application.routes.draw do
  root :to => 'pages#home'
  get  '/dashboard' => 'accounts#dashboard', :as => :user_root

  # Admin
  get '/admin' => 'admin#index'

  # Static Pages
  { '/time'     => :time,
    #'/features' => :features,
    '/about'    => :about,
    #'/jobs'     => :jobs,
    '/contact'  => :contact,
    '/help'     => :help,
    '/privacy'  => :privacy,
    '/terms'    => :terms
  }.each do |url, name|
    get url, :controller => 'pages',:action => name, :as => "#{name}_page"
  end

  # Authentication
  devise_for :users, :skip => :all do
    get    '/login' => 'devise/sessions#new', :as => :new_user_session
    post   '/logout' => 'devise/sessions#create', :as => :user_session
    delete '/logout' => 'devise/sessions#destroy', :as => :destroy_user_session

    get  '/signup/check' => 'users#check'
    get  '/signup' => 'users#new', :as => :new_user
    post '/users' => 'users#create', :as => :users
  end

  get  '/worlds/new' => 'worlds#new', :as => :new_world
  post '/worlds' => 'worlds#create', :as => :worlds

  resource :upload, :path => '/worlds/upload', :only => [:new, :create], :path_names => {:new => '/'} do
    get :policy
  end
  
  controller :stripe, :path => :customer, :as => :customer do
    get :new
    put :create
  end

  resource :account, :except => [:new, :edit, :destroy] do
    get :billing
    resources :plans, :only => :show
    resources :time_packs,  :only => :show
  end
  
  as :user do
    resources :users, :path => 'players', :only => [:show]
  end

  resources :worlds, :only => [:show, :edit, :update] do

    member do
      get  :map
      put :play
    end

    resources :wall_items, :only => [:index, :create]
    resources :players, :only => [:index, :create, :destroy] do
      post :ask, :action => :ask, :on => :collection
      post :add, :action => :add, :on => :collection
      get  :search, :action => :search, :on => :collection

      put :approve, :on => :collection
    end

    resource :invite, :only => :create
  end
  
  resource :order, :only => [] do
    post :subscribe
    post :purchase_time
  end

  post '/stripe/webhook' => 'stripe#webhook'

end
