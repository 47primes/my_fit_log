require 'spec_helper'

describe API::ApplicationController do
  
  controller do
    respond_to :json
    before_filter :validate_request_content_type, :validate_request_device_header
    before_filter :validate_api_key, only: :create
    
    def index
      head :no_content
    end

    def create
      head :no_content
    end

    def new
      raise "Error!"
    end
  end

  describe "api_version" do
    it "should set the value from the 'Accept' request header" do
      @request.env["Accept"] = "application/vnd.my_fit_log.v3"
      @request.env[API::ApplicationController::DEVICE_HEADER_KEY] = "MyFitLog iOS"
      @request.env["Content-Type"] = "application/json"
      get :index, {format: "json"}
      
      assert @controller.api_version.should == "3"
    end
    
    it "should set a default value when no 'Accept' request header is sent" do
      @request.env[API::ApplicationController::DEVICE_HEADER_KEY] = "MyFitLog iOS"
      @request.env["Content-Type"] = "application/json"
      get :index, {format: "json"}
      
      assert @controller.api_version.should == "1"
    end
    
    it "should set a default value when the 'Accept' request header format is unrecognizable" do
      @request.env["Accept"] = "application/vnd.v3"
      @request.env[API::ApplicationController::DEVICE_HEADER_KEY] = "MyFitLog iOS"
      @request.env["Content-Type"] = "application/json"
      get :index, {format: "json"}
      
      assert @controller.api_version.should == "1"
    end
  end
  
  describe "validate_request_device_header" do
    describe "with an invalid device request header" do
      before do
        @request.env[API::ApplicationController::DEVICE_HEADER_KEY] = "iPhone"
        @request.env["Content-Type"] = "application/json"
        get :index, {format: "json"}
      end
      
      it { should respond_with(:bad_request) }
    end
  end
  
  describe "validate_request_content_type" do
    describe "with an invalid content type request header" do
      before do
        @request.env[API::ApplicationController::DEVICE_HEADER_KEY] = "MyFitLog iOS"
        @request.env["Content-Type"] = "text/html"
        post :create, {format: "json"}
      end
      
      it { should respond_with(:unsupported_media_type) }
    end
  end
  
  describe "validate_api_key" do
    describe "with an invalid api_key" do
      before do
        @request.env["Accept"] = "application/vnd.my_fit_log.v2"
        @request.env[API::ApplicationController::DEVICE_HEADER_KEY] = "MyFitLog iOS"
        @request.env["Content-Type"] = "application/json"
        @request.env[API::ApplicationController::API_HEADER_KEY] = "adfjaeje"
        post :create, {format: "json"}
      end
      
      it { should respond_with(:unauthorized) }
    end
  end
  
  describe "handle_exception" do
    describe "when an exception is raised" do
      before do
        @request.env["Accept"] = "application/vnd.my_fit_log.v2"
        @request.env[API::ApplicationController::DEVICE_HEADER_KEY] = "MyFitLog iOS"
        @request.env["Content-Type"] = "application/json"
        @request.env[API::ApplicationController::API_HEADER_KEY] = "adfjaeje"
        get :new, {format: "json"}
      end
      
      it { should render_template("api/v2/500") }
      it { should respond_with(:internal_server_error) }
    end
  end

end
