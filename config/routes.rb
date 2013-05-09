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

  # Webhooks
  scope path: 'webhooks', module: 'webhooks' do
    post 'mailgun' => 'mailgun#create'
    post 'party_cloud' => 'party_cloud#create'
    post 'stripe' => 'stripe#create'
    post 'zim' => 'zim#create'
  end

  # Legacy Zim callback
  post '/hooks/zim/map_deleted' => 'webhooks/zim#create'

# --


  # Static Pages

  { '/about'   => :about,
    '/developers' => :developers,
    '/time'    => :time,
    '/home'    => :home,
    '/pricing' => :pricing,
    '/plans'   => :plans,
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

  resources :stats, only: [] do
    get :sessions, :on => :collection
  end

  resources :funpacks, path: '/games', only: [:show]


  # Authenticated routes
  as :user do

    # Devise overrides
    get '/settings' => 'devise/registrations#edit', :as => :edit_user_registration
    get '/resend_confirmation' => 'users#resend_confirmation', :as => :resend_confirmation

    get '/i/:invitation_token' => 'invitations#show', :as => :invitation

    resources :invitations, only: [:create]

    resources :accounts do
      get :link_mojang, :on => :collection
    end

    resource :account, only:[] do
      get :bonus
    end

    resources :gifts do
      get :cheers, :on => :member
      get :certificate, :on => :member

      get :redeem, :on => :collection
      post :redeem, :action => :redeem_action, :on => :collection
    end

    match '/redeem' => redirect('/gifts/redeem')

    resources :orders, only: [:create, :show]
    resources :subscriptions, only: [:create, :show] do
      get :thank_you, :on => :collection
    end

    resources :servers, path_names: {edit: 'settings'} do
      collection do
        get 'list'
        get 'list/*start_index' => 'servers#list'
      end

      member do
        post :start
        post :stop
        get :logs

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

    resources :users, path: '/',
                      only: [:show, :update] do
       get :onboard, :on => :collection, path: 'welcome'
    end
  end

  root to: 'pages#home'

end
