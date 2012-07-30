# $ deploy:install
# $ deploy:setup
# $ deploy:cold

require "bundler/capistrano"
load "deploy/utilities"
load "deploy/recipes/deploy"
load "deploy/recipes/rbenv"
load "deploy/recipes/nginx"
load "deploy/recipes/postgresql"
load "deploy/recipes/unicorn"
load "deploy/recipes/app"

set :deploy_as, "admin"
set :application, "my_fit_log"
set :deploy_to, "/users/#{deploy_as}/deploy/#{application}/"

set :scm, :git
set :repository,  "git@github.com:47primes/#{application}.git"
set :branch, "master"
set :copy_exclude,  [".DS_Store", ".git", "test", "doc"]

set :deploy_via, :remote_cache
set :keep_releases, 5
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

server "192.168.0.1", :app, :web, :db, primary: true

after "deploy", "deploy:cleanup"
