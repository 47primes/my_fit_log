namespace :app do
  desc "Tail the Rails log"
  task :tail, roles: :app do
    run "tail -f #{shared_path}/log/#{stage}.log" do |channel, stream, data|
      puts
      puts "#{channel[:server]} -> #{data}"
      break if stream == :err
    end
  end
end
