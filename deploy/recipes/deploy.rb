namespace :deploy do
  desc "set system timezone"
  task :timezone, roles: [:app, :web, :db] do
    run "echo \"America/Chicago\" | #{sudo} tee /etc/timezone"
    run "#{sudo} dpkg-reconfigure --frontend noninteractive tzdata"
  end
  
  desc "Install everything onto the server"
  task :install, roles: :app do
    run_with_password "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install python-software-properties make libxslt-dev libxml2-dev"
  end
  before "deploy:install", "deploy:timezone"
  
end
