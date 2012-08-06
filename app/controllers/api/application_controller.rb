module Api
  class ApplicationController < ActionController::Base
    respond_to :json
    rescue_from StandardError, with: :handle_exception
    rescue_from Exception, with: :handle_exception
    before_filter :log_request_headers, :set_api_version
    attr_reader :api_version
    
    protected
    
    def log_request_headers
      request.headers.each do |header, value|
        logger.info "[#{header}] = #{value}"
      end
    end

    def set_api_version
      @api_version = /application\/vnd\.my_fit_log\.v(\d+)/.match(request.headers["Accept"]).to_a.last || "1"
    end
    
    def validate_request_content_type
      self.class.mimes_for_respond_to.keys.each do |mime|
        if (request.post? || request.put?) && request.headers["CONTENT_TYPE"] != Mime::Type.lookup_by_extension(mime).to_s
          return head(:unsupported_media_type)
        end
      end
    end

    def validate_request_device_header
      return head(:bad_request) unless request.headers["User-Agent"] =~ /MyFitLog (Android|iOS)/
    end
    
    def validate_api_key
      @user = User.find_by_api_key(request.headers["From"])
      return head(:unauthorized) if @user.nil?
    end

    def handle_exception(exception)
  		logger.error "#{exception.message}\n#{exception.backtrace.join("\n")}"
  		# Email error to admin 
  		respond_to do |format|
        self.class.mimes_for_respond_to.keys.each do |mime|
          format.send(mime) { render template: "api/v#{@api_version}/500", status: :internal_server_error }
        end
      end
      return
    end
  end
end
