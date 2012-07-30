def get_env(name, default = "")
  key = ENV.keys.find { |k| k.downcase == name.to_s.downcase }
  return default unless key
  ENV[key]
end

def _set(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def put_template(from, to)
  erb = File.read(File.join(File.dirname(__FILE__),"templates/#{from}"))
  put ERB.new(erb).result(binding), to
end

def run_with_password(command)
  _set(:unix_password) { Capistrano::CLI.password_prompt "Enter UNIX password: " }
  run command,:pty => true do |ch, stream, data|
    if data =~ /password/
      #prompt, and then send the response to the remote process
      ch.send_data(unix_password + "\n")
    else
      #use the default handler for all other text
      Capistrano::Configuration.default_io_proc.call(ch,stream,data)
    end
  end
end
