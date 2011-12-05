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

    get  '/signup/check' => 'users#check'
    get  '/signup' => 'users#new', :as => :new_user
    post '/users' => 'users#create', :as => :users
  end

  resource :upload, :path => '/worlds/upload', :only => [:new, :create], :path_names => {:new => '/'} do
    get :policy
  end

  controller :stripe, :path => :customer, :as => :customer do
    get :new
    put :create
  end

  resource :account, :except => [:new, :show, :destroy], :path_names => {:edit => '/'} do
    get :billing
    resources :plans, :only => :show
    resources :time_packs,  :only => :show
  end

  as :user do
    resources :users, :path => 'players', :only => [:show]
  end

  resources :worlds, :except => :destroy, :path_names => {:edit => 'settings'} do

    member do
      get  :map
      get  :invite
      put :play
    end

    resources :events, :only => [:index, :create]
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
