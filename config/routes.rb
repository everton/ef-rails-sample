require 'resque/server'

VideoPublicationExample::Application.routes.draw do
  mount Resque::Server.new, at: "/resque"

  resources :videos

  get '/login'    => 'sessions#new',     as: :login
  get '/logout'   => 'sessions#destroy', as: :logout

  post '/session' => 'sessions#create'

  namespace :admin do
    resources :users, except: :show
  end

  root 'videos#index'
end
