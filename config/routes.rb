class GameConstraint
  def initialize
    @game_slugs = Game.all.map(&:slug)
  end

  def matches?(req)
    # raise request.inspect
    @game_slugs.include?(req.params['game_id'] || req.params['id'])
  end
end

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

  resources :games, path: '/', only: [:show], constraints: GameConstraint.new do
    resources :funpacks, path: '/', only: [:show]
  end

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
      member do
        get :map
        post :start
        post :stop

        controller 'servers/watchers' do
          post 'watch', :action => :create
          post 'unwatch', :action => :destroy
        end

      end

      resources :votes, :only => [:create]

      resources :posts, only: [:create], module: 'servers'

      resources :uploads, only: [:create], module: 'servers' do
        collection do
          get :sign
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
