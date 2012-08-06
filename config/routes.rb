require 'route_constraints'

MyFitLog::Application.routes.draw do
  api_routes = lambda do
    resource :sessions, only: :create
    resource :user, only: [:create, :update] do
      post 'reset_password', on: :collection
      resources :exercises, only: [:create, :show, :index, :update, :destroy] do
        get 'page/:page', action: :index, on: :collection
      end
      resources :workouts, only: [:create, :show, :index, :update, :destroy] do
        get 'page/:page', action: :index, on: :collection
        resources :routines, only: [:create, :show, :index, :update, :destroy] do
          get 'page/:page', action: :index, on: :collection
        end
      end
    end
  end
  
  scope module: :api, constraints: {format: "json"} do
    scope module: "v1", constraints: [RouteConstraints.new(version: 1, default: true)], &api_routes
    scope module: "v2", constraints: [RouteConstraints.new(version: 2)], &api_routes
  end
end
