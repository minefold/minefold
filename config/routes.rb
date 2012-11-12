# Hash rocket stylee please. Routes typically have lots of symbol to symbol hashes so keeping the same style throughout it prettier.

Minefold::Application.routes.draw do
  admin_only = lambda {|req| (u = req.env['warden'].user) and u.admin? }

  constraints(admin_only) do
    mount Resque::Server, :at => '/admin/resque'
  end

  if Rails.env.development?
    get '/tumblr' => 'tumblr#index'
    get '/playground' => 'pages#playground'
  end


# --

  # Static Pages

  { '/about'    => :about,
    '/getcredits' => :getcredits,
    '/support'  => :support,
    '/jobs'     => :jobs,
    '/pricing'  => :pricing,
    '/privacy'  => :privacy,
    '/terms'    => :terms
  }.each do |url, name|
    get url, :controller => 'pages',:action => name, :as => "#{name}_page"
  end

  post '/pusher/auth' => 'pusher#auth'

  get '/channel.html' => 'facebook#channel', :as => :facebook_channel


  devise_for :user, :controllers => {
                      :omniauth_callbacks => 'omniauth_callbacks',
                      :registrations => 'registrations'
                    }

  # Authenticated routes
  as :user do

    get '/settings' => 'devise/registrations#edit', :as => :edit_user_registration

    resource :orders, :only => [:new, :create]

    resources :servers, :path_names => {:edit => 'settings'} do
      get :new_funpack_settings, :on => :collection

      get :map, :on => :member
      put :extend, :on => :member

      resources :comments, :only => [:create], :module => 'servers'

      get 'policy.xml',
        :controller => 'servers/uploads',
        :action => :policy,
        :format => :xml,
        :on => :collection
    end

    scope '/users/accounts', :controller => 'accounts', :as => :accounts do
      put :unlink_facebook

      get :link_minecraft
      put :unlink_minecraft
    end

    authenticated do
      root :to => 'servers#index', :as => :user_root
    end

    resources :users, :path => '/',
                      :only => [:show, :update] do
       get :onboard, :on => :collection, :path => 'welcome'
    end
  end

  root :to => 'pages#home'

end
