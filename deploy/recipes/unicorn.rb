_set(:unicorn_user) { deploy_as }
_set(:unicorn_pid) { "#{current_path}/tmp/pids/unicorn.pid" }
_set(:unicorn_config) { "#{shared_path}/config/unicorn.rb" }
_set(:unicorn_log) { "#{shared_path}/log/unicorn.log" }
_set(:unicorn_application) { "unicorn_#{application}" }
_set(:unicorn_workers, 2)

namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    put_template "unicorn.rb.erb", unicorn_config
    put_template "unicorn_init.erb", "/tmp/unicorn_init"
    run "chmod +x /tmp/unicorn_init"
    run "#{sudo} mv /tmp/unicorn_init /etc/init.d/#{unicorn_application}"
    run "#{sudo} update-rc.d -f #{unicorn_application} defaults"
  end
  after "deploy:setup", "unicorn:setup"

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command, :roles => :app do
      run "service #{unicorn_application} #{command}"
    end
    after "deploy:#{command}", "unicorn:#{command}"
  end
end
