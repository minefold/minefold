# Hash rocket stylee please

Minefold::Application.routes.draw do
  admin_only = lambda {|req| (u = req.env['warden'].user) and u.admin? }

  constraints(admin_only) do
    mount Resque::Server, :at => '/admin/resque'
  end

  # Static Pages

  { '/about'    => :about,
    '/support'  => :support,
    '/jobs'     => :jobs,
    '/pricing'  => :pricing,
    '/privacy'  => :privacy,
    '/terms'    => :terms,
    '/welcome'  => :welcome
  }.each do |url, name|
    get url, :controller => 'pages',:action => name, :as => "#{name}_page"
  end

  post '/pusher/auth' => 'pusher#auth'

  get '/channel.html' => 'facebook#channel', :as => :facebook_channel


  devise_for :user,
    :controllers => { :omniauth_callbacks => 'omniauth_callbacks' }

  # Authentication
  devise_scope :user do

    resource :order, :only => [:create]

    resources :games

    resources :servers do
      get :map, :on => :member

      resources :memberships

      get 'policy.xml',
        :controller => 'servers/uploads',
        :action => :policy,
        :format => :xml,
        :on => :collection
    end

    authenticated do
      root :to => 'servers#index', :as => :user_root
    end

    resources :users, :path => '/',
                      :only => [:show, :update]
  end

  root :to => 'pages#home'


  # resources(:players,
  #           :path => '/',
  #           :only => [:show]) do
  #
  #   resources(:worlds,
  #             :path => '/',
  #             :except => [:index, :new, :create],
  #             :path_names => {:edit => 'settings'}) do
  #
  #     member do
  #       put :clone
  #       get :invite
  #     end
  #
  #     scope :module => :worlds do
  #       resources :players, :controller => :memberships, :only => [:index, :create, :destroy]
  #
  #       resources :membership_requests, :only => [:create, :destroy] do
  #         put :approve, :on => :member
  #       end
  #
  #       resources :comments, :only => [:create]
  #     end
  #   end
  #
  # end

end
