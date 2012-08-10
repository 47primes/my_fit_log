require 'route_constraints'

MyFitLog::Application.routes.draw do
  api_routes = -> {
    resource :sessions, only: :create
    resource :user, only: [:create, :update] do
      post 'reset_password', on: :collection
      resources :exercises, only: [:create, :show, :index, :update, :destroy]
      resources :workouts, only: [:create, :show, :index, :update, :destroy] do
        resources :routines, only: [:create, :show, :index, :update, :destroy]
      end
    end
  }

  scope module: :api, constraints: {format: "json"} do
    scope module: "v2", constraints: RouteConstraints.new(version: 2), &api_routes
    scope module: "v1", constraints: RouteConstraints.new(version: 1, default: true), &api_routes
  end
end


