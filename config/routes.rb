Minefold::Application.routes.draw do

  root :to => 'home#index'
  get '/dashboard' => 'users#dashboard', :as => :user_root


  # Authentication
  devise_for :users, :skip => [:sessions, :passwords, :registrations] do
    get  '/sign-in',
      :to => 'devise/sessions#new', :as => :new_user_session
    post '/sign-in',
      :to => 'devise/sessions#create', :as => :user_session
    delete '/sign-out',
      :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  { '/about'   => 'about',
    '/jobs' => 'jobs',
    '/contact' => 'contact',
    '/help'    => 'help',
    '/privacy' => 'privacy',
    '/terms'   => 'terms'
  }.each do |url, name|
    get url => 'high_voltage/pages#show', :id => name
  end

  # devise_for :users

  get '/sign-up' => 'users#new'

                     # :path_names => {
                     #   :sign_up => '/sign_up/:code',
                     #   :sign_out => '/sign-out',
                     #   :sign_in => '/sign-in'
                     # }

  # resource :account

  # Payment
  get  '/time' => 'orders#new', :as => :credits
  post '/order' => 'orders#create', :as => :order
  get  '/order/success' => 'orders#success', :as => :successful_order
  get  '/order/cancel' => 'orders#cancel', :as => :cancel_order

  get  '/referrals' => 'referrals#new', :as => :new_referral
  post '/referrals' => 'referrals#create', :as => :referrals
  # resources :referrals, :only => [:create]

  resources :worlds, :only => [:new, :create]

  get '/explore' => 'worlds#index', :as => :worlds
  # get '/:user_id/:world_id/wall/page/:page' => 'wall_items#index'
  # get '/:user_id/:world_id/wall/page/:page' => 'wall_items#index'
  scope '/:user_id/:id' do
    get '/map' => 'worlds#map', :as => :map_world
    get '/photos' => 'worlds#photos', :as => :photos_world
    get '/edit' => 'worlds#edit', :as => :edit_world

    resources :wall_items, :only => [:index, :create]

    get '/' => 'worlds#show', :as => :world
    # get '/wall/page/:page' => 'wall_items#show', :as => :world_wall_items
  end

  get '/account' => 'users#edit', :as => :account
  get '/:id' => 'users#show', :as => :user
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

  if Rails.env.development?
    mount OrderMailer::Preview => '/dev/order-mail'
    mount UserMailer::Preview => '/dev/user-mail'
  end

end
