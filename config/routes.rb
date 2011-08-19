Minefold::Application.routes.draw do

   root :to => 'home#index'

  # Authentication
  devise_for :users, :controllers => {
                       :registrations => :registrations
                     },
                     :path_names => {
                       :sign_up => '/sign_up/:code'
                     }

  get '/dshbrd' => 'accounts#dashboard', :as => :user_root
  resource :account

  # Payment
  get  '/buy' => 'orders#new', :as => :credits
  post '/order' => 'orders#create', :as => :order
  get  '/order/success' => 'orders#success', :as => :successful_order
  get  '/order/cancel' => 'orders#cancel', :as => :cancel_order

  get '/referrals' => 'invites#index', :as => :referrals
  resources :invites, :only => [:create]

  get '/about' => 'high_voltage/pages#show', :id => 'about'

  resources :worlds do
    resources :wall_items do
      get 'page/:page' => 'wall_items#page', :on => :collection
    end

    collection do
      post :import
      get :import_policy, :format => :xml
    end

    member do
      post :activate
      get  :map
    end
  end


  mount Resque::Server, :at => '/resque'
  get '/admin' => 'admin#index', :as => :admin
end
