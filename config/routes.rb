Minefold::Application.routes.draw do

  root to: 'users#dashboard',
       constraints: ->(req){ req.env['warden'].authenticated? },
       as: :dashboard

  root :to => 'home#teaser'


  # Signup
  get  '/sign_up' => 'users#new'
  post '/sign_up' => 'users#create', :as => :users


  # Authentication
  get    '/sign_in'  => 'sessions#new',  :as => :new_session
  post   '/sign_in'  => 'sessions#create',  :as => :sessions
  get    '/sign_out' => 'sessions#destroy', :as => :session
  get    '/unauthorized' => 'sessions#unauthorized', :as => :unauthorized

  # Payment
  get  '/credits' => 'orders#new', :as => :credits
  post '/order' => 'orders#create', :as => :order
  get  '/order/success' => 'orders#success', :as => :successful_order
  get  '/order/cancel' => 'orders#cancel', :as => :cancel_order



  # Players
  get  '/player/:username' => 'user#show'


  # Worlds
  resources :worlds, :only => [:new, :create] do
    post 'activate', :on => :member
  end

  get '/:id' => 'worlds#show', :as => :world


  # Playground
  get '/the-shaft' => 'worlds#show'
end
