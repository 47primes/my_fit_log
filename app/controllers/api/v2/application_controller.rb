class API::V2::ApplicationController < API::ApplicationController
  before_filter :validate_request_device_header, :validate_request_content_type
end
