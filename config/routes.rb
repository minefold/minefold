Minefold::Application.routes.draw do

# Constraints

  @admins = ->(req) { (u = req.env['warden'].user) && u.admin? }
  @development = ->(req) { Rails.env.development? }
  @feature = ->(feature) { ->(req) { u = req.env['warden'].user && false } }

# --

  constraints(@admins) do
    mount Resque::Server, at: '/admin/resque'
  end

  constraints(@development) do
    get '/tumblr' => 'tumblr#index'
    get '/playground' => 'pages#playground'
  end


# --

  # Static Pages

  { '/about'      => :about,
    '/getcoins' => :getcoins,
    '/support'    => :support,
    '/jobs'       => :jobs,
    '/pricing'    => :pricing,
    '/privacy'    => :privacy,
    '/terms'      => :terms
  }.each do |url, name|
    get url, controller: 'pages', action: name, as: "#{name}_page"
  end

  post '/pusher/auth' => 'pusher#auth'

  get '/channel.html' => 'facebook#channel', :as => :facebook_channel

  resources :funpacks

  devise_for :user, controllers: {
                      omniauth_callbacks: 'omniauth_callbacks',
                      registrations: 'registrations'
                    }

  # Christmas Promotion
  get '/xmas' => 'gifts#index', :as => :xmas_promo
  get '/xmas/:id/cheers' => 'gifts#cheers', :as => :xmas_cheers

  resources :gifts do
    get :cheers, :on => :member
    get :certificate, :on => :member
  end


  # Authenticated routes
  as :user do

    # Devise overrides
    get '/settings' => 'devise/registrations#edit', :as => :edit_user_registration

    get '/i/:invitation_token' => 'invitations#show', :as => :invitation


    resources :orders, only: [:create, :show]

    resources :servers, path_names: {edit: 'settings'} do
      collection do
        get :new_funpack_settings
      end

      member do
        get :map

        put :start

        post :watch
        post :unwatch

      end

      resources :votes, :only => [:create]

      resources :comments, only: [:create], module: 'servers'
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
