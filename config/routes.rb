Minefold::Application.routes.draw do

   root :to => 'home#teaser'

  get '/dshbrd' => 'users#dashboard', :as => :user_root

#   # Authentication
  devise_for :users, :controllers => {
                       :registrations => :registrations
                     },
                     :path_names => {
                       :sign_up => '/sign_up/:code'
                     }

  resources :invites, :only => [:create]

  get '/admin' => 'admin#index', :as => :admin

  # Payment
  get  '/credits' => 'orders#new', :as => :credits
  post '/order' => 'orders#create', :as => :order
  get  '/order/success' => 'orders#success', :as => :successful_order
  get  '/order/cancel' => 'orders#cancel', :as => :cancel_order

  # Worlds

  resources :world_imports, :only => [:create]

  mount Resque::Server, :at => '/resque'

  get '/about' => 'high_voltage/pages#show', :id => 'about'

  resources :worlds do
    resources :wall_items
    post :activate, :on => :member
    get  :map, :on => :member
  end

  resources :uploads, :only => :index
end
