_set(:postgresql_host, "localhost")
_set(:postgresql_user) { "admin" }
_set(:postgresql_password) { Capistrano::CLI.password_prompt "PostgreSQL Password: " }
_set(:postgresql_database) { "#{application}_#{Rails.env}" }

namespace :postgresql do
  desc "Install the latest stable release of PostgreSQL"
  task :install, roles: :db, only: {primary: true} do
    run "#{sudo} add-apt-repository -y ppa:pitti/postgresql"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install postgresql libpq-dev"
  end
  after "deploy:install", "postgresql:install"

  desc "Create a databases for this application."
  task :create_databases, roles: :db, only: {primary: true} do
    run %Q{#{sudo} -u postgres psql -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
    run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
  end
  after "deploy:setup", "postgresql:create_databases"

  desc "Generate the database.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    put_template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "postgresql:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "postgresql:symlink"
end
