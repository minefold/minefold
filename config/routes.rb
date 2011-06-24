Minefold::Application.routes.draw do
  root :to => 'home#index'

  post '/player' => 'user#create', :as => :users

  # resources :worlds


  devise_for :users, path: 'player'

  get '/worlds/new' => 'worlds#new', :as => :world_new
  post '/worlds' => 'worlds#create'
  post '/:name/activate' => 'worlds#activate', :as => :world_activate
  get  '/:name' => 'worlds#show', :as => :world
end
