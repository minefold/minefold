Minefold::Application.routes.draw do
  admin_only = lambda {|req| (u = req.env['warden'].user) and u.admin? }

  constraints(admin_only) do
    mount Resque::Server, at: '/admin/resque'
  end

  if Rails.env.development?
    get '/tumblr' => 'tumblr#index'
    get '/playground' => 'pages#playground'
  end


# --

  # Static Pages

  { '/about'      => :about,
    '/getcredits' => :getcredits,
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


  devise_for :user, controllers: {
                      omniauth_callbacks: 'omniauth_callbacks',
                      registrations: 'registrations'
                    }

  # Authenticated routes
  as :user do
    # Devise overrides
    get '/settings' => 'devise/registrations#edit', :as => :edit_user_registration

    resource :orders, only: [:create]

    resources :invitations, path: 'i', only: [:show]

    resources :servers, path_names: {edit: 'settings'} do
      collection do
        get :new_funpack_settings
      end

      member do
        get :map
        put :extend
      end

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
