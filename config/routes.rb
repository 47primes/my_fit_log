require 'route_constraints'

MyFitLog::Application.routes.draw do
  def api_routes(version=1)
    lambda do
      resource :sessions, only: :create, as: "v#{version}_session"
      resource :user, only: [:create, :update], as: "v#{version}_user" do
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
  end
  
  scope module: :api, constraints: {format: "json", subdomain: "api"} do
    scope module: "v1", constraints: [RouteConstraints.new(version: 1, default: true)], &method(:api_routes).call
    scope module: "v2", constraints: [RouteConstraints.new(version: 2)], &method(:api_routes).call(2)
  end
end
