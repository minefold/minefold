Minefold::Application.routes.draw do

  root :to => 'users#dashboard',
       :as => :user_root,
       :constraints => ->(req){req.env["warden"].authenticated?}

  root :to => 'home#teaser'

#   # Authentication
  devise_for :users, :controllers => {
                       :registrations => :registrations
                     },
                     :path_names => {
                       :sign_up => '/sign_up/:code'
                     }

  post '/subscribe' => 'home#subscribe', :as => :subscribe

  get '/admin' => 'admin#index', :as => :admin

  # resources :users


  # devise_for :users

  # get  '/users/sign_up/:code' => 'users#new'
  # post '/users/sign_up' => 'users#create'

  resources :invites, :only => [:create]

  get '/users/sign_up/:code' => 'users#new', :as => :invite


  # Payment
  get  '/credits' => 'orders#new', :as => :credits
  post '/order' => 'orders#create', :as => :order
  get  '/order/success' => 'orders#success', :as => :successful_order
  get  '/order/cancel' => 'orders#cancel', :as => :cancel_order


  resources :uploads, :only => :index

  # Worlds

  resources :world_imports, :only => [:create]

  mount Resque::Server, :at => '/resque'

  get '/about' => 'high_voltage/pages#show', :id => 'about'

  resources :worlds do
    resources :wall_items
    post :activate, :on => :member
  end

  # get  '/worlds/new' => 'worlds#new', :as => :new_world
  # post '/worlds' => 'worlds#create', :as => :worlds
  # post '/:id/activate' => 'worlds#activate', :as => :activate_world
  # post '/:id/chat' => 'worlds#chat', :as => :chat_world
  # get  '/:id' => 'worlds#show', :as => :world
end
