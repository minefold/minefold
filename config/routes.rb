Minefold::Application.routes.draw do

   root :to => 'home#teaser'

#   # Authentication
  devise_for :users, :controllers => {
                       :registrations => :registrations
                     },
                     :path_names => {
                       :sign_up => '/sign_up/:code'
                     }

  get '/dshbrd' => 'accounts#dashboard', :as => :user_root
  resource :account


  resources :invites, :only => [:create]

  get '/admin' => 'admin#index', :as => :admin

  # Payment
  get  '/credits' => 'orders#new', :as => :credits
  post '/order' => 'orders#create', :as => :order
  get  '/order/success' => 'orders#success', :as => :successful_order
  get  '/order/cancel' => 'orders#cancel', :as => :cancel_order

  # Worlds

  mount Resque::Server, :at => '/resque'

  get '/about' => 'high_voltage/pages#show', :id => 'about'

  resources :worlds do
    resources :wall_items
    post :activate, :on => :member
    get  :map, :on => :member

    post :import
  end

  get '/s3_uploads' => 'upload_policy#index', :format => :xml
end
