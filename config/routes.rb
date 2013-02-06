require './lib/games'
require './lib/static_game_constraint'

Minefold::Application.routes.draw do

# Constraints

  @admins = ->(req) { (u = req.env['warden'].user) && u.admin? }
  @development = ->(req) { Rails.env.development? }
  @feature = ->(feature) { ->(req) { u = req.env['warden'].user && false } }

# --

  constraints(@admins) do
    mount Resque::Server, at: '/admin/resque'
  end

# --

  scope path: 'webhooks', module: 'webhooks' do
    post '/party_cloud', controller: 'party_cloud', action: 'hook'
  end

# --


  # Static Pages

  { '/about'   => :about,
    '/time'    => :time,
    '/home'    => :home,
    '/pricing' => :pricing,
    '/privacy' => :privacy,
    '/help'    => :support,
    '/terms'   => :terms
  }.each do |url, name|
    get url, controller: 'pages', action: name, as: "#{name}_page"
  end

  # redirect sitemap requests to cloudfront
  match "/sitemap*path" => redirect {|p, req|
    "#{ENV['ASSET_HOST']}/sitemap#{p[:path]}.#{p[:format]}"
  }

  post '/pusher/auth' => 'pusher#auth'

  get '/channel.html' => 'facebook#channel', :as => :facebook_channel

  devise_for :user, controllers: {
                      omniauth_callbacks: 'omniauth_callbacks',
                      registrations: 'registrations'
                    }

  # Christmas Promotion
  get '/xmas' => 'gifts#index', :as => :xmas_promo
  get '/xmas/:id/cheers' => 'gifts#cheers', :as => :xmas_cheers

  controller :explore, path: '/explore' do

    get '/', :action => :index
  end

  # Webhooks
  post '/hooks/zim/map_deleted' => 'zim_callbacks#map_deleted'

  # Authenticated routes
  as :user do

    # Devise overrides
    get '/settings' => 'devise/registrations#edit', :as => :edit_user_registration

    get '/i/:invitation_token' => 'invitations#show', :as => :invitation

    resources :accounts do
      get :link_mojang, :on => :collection
    end

    resources :gifts do
      get :cheers, :on => :member
      get :certificate, :on => :member

      get :redeem, :on => :collection
      post :redeem, :action => :redeem_action, :on => :collection
    end

    match '/redeem' => redirect('/gifts/redeem')

    resources :orders, only: [:create, :show]

    resources :servers, path_names: {edit: 'settings'} do
      collection do
        get 'list'
        get 'list/*start_index' => 'servers#list'
      end

      member do
        post :start
        post :stop

        controller 'servers/watchers' do
          post 'watch', :action => :create
          post 'unwatch', :action => :destroy
        end

        controller 'servers/stars' do
          post 'star', :action => :create
          post 'unstar', :action => :destroy
        end

        controller 'servers/gameplay' do
          put 'gameplay', :action => :update
        end
      end

      scope module: 'servers' do
        resources :posts, only: [:create]
        resource :map, only: [:show] do
          get :embed
        end
        resources :uploads, only: [:create] do
          get :sign, :on => :collection
        end
      end
    end

    scope '/users/accounts', controller: 'accounts', :as => :accounts do
      put :unlink_facebook

      get :link_minecraft
      put :unlink_minecraft
    end

    authenticated do
      root to: 'servers#index', :as => :user_root
    end

    constraints StaticGameConstraint.new(GAMES) do
      resources :games, path: '/', only: [:show] do
        resources :funpacks, path: '/', only: [:show]
      end
    end

    resources :users, path: '/',
                      only: [:show, :update] do
       get :onboard, :on => :collection, path: 'welcome'
    end
  end

  root to: 'pages#home'

end
