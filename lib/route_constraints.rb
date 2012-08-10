class RouteConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(request)
    @default || request.headers["Accept"].include?("application/vnd.my_fit_log.v#{@version}")
  end
end
