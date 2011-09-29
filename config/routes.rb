Minefold::Application.routes.draw do
  root :to => 'home#index'
  get  '/dashboard' => 'home#dashboard', :as => :user_root

  # Admin
  get '/admin' => 'admin#index'
  namespace :admin do
    mount Resque::Server => 'resque'

    if Rails.env.development?
      namespace :mail do
        mount OrderMailer::Preview => 'order'
        mount UserMailer::Preview => 'user'
        mount WorldMailer::Preview => 'world'
      end
    end
  end

  # Static Pages
  { '/about'   => 'about',
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
    get    '/sign-in' => 'devise/sessions#new', :as => :new_user_session
    post   '/sign-in' => 'devise/sessions#create', :as => :user_session
    delete '/sign-out' => 'devise/sessions#destroy', :as => :destroy_user_session

    get  '/sign-up' => 'users#new', :as => :new_user
    post '/users' => 'users#create', :as => :users
  end

  resource :order do
    get :success
    get :cancel
  end

  as :user do

    resources :users, :path => '/',
                      :only => [:show, :update],
                      :path_names => {:edit => 'settings'} do

      get 'account', :action => :edit, :as => :edit, :on => :member

      resources :worlds, :path => '/', :only => [:show, :edit, :update] do
        collection do
          get  'worlds/new', :action => :new, :as => :new
          post 'worlds/new', :action => :create, :as => nil

          resource :upload, :path => 'worlds/upload', :only => [:new, :create] do
            get :policy
          end
        end

        member do
          get  :map
          post :play
        end

        resources :wall_items, :only => [:index, :create]
        resources :players, :only => [:index, :create, :destroy]
      end
    end

  end
end
