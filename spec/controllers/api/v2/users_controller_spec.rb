require "spec_helper"

describe API::V2::UsersController do
  before do
    @request.env["Accept"] = "application/vnd.truth_packer.v2"
    @request.env[API::ApplicationController::DEVICE_HEADER_KEY] = "MyFitLog Android"
    @request.env["Content-Type"] = "application/json"
  end
  
  context "POST to create" do
    context "with valid attributes" do
      before do
        post :create, {:user => {:name => "Mike", :email => "test@test.com", :password => "test", 
                                 :password_confirmation => "test"}, :format => "json"}
      end

      it { should respond_with(:created) }
      it { @controller.response.location.should =~ /user\.\d+/ }
    end

    context "should fail if email already exists" do 
      before do
        User.create!(:name => "Mike", :email => "test@test.com", :password => "test", :password_confirmation => "test")
        post :create, {:user => {:name => "Mike", :email => "test@test.com", :password => "testing", 
                                 :password_confirmation => "testing"}, :format => "json"}
      end

      it { should respond_with(:unprocessable_entity) }
    end

    context "should fail with invalid email" do
      before do
        post :create, {:user => {:name => "Mike", :email => "test@test", :password => "test", 
                                 :password_confirmation => "test"}, :format => "json"}
      end

      it { should respond_with(:unprocessable_entity) }
    end

    context "should fail if missing email" do
      before do
        post :create, {:user => {:name => "Mike", :password => "test", :password_confirmation => "test"}, :format => "json"}
      end

      it { should respond_with(:unprocessable_entity) }
    end

    context "should fail if missing password" do
      before do
        post :create, {:user => {:name => "Mike", :email => "test@test.com"}, :format => "json"}
      end

      it { should respond_with(:unprocessable_entity) }
    end

    context "should fail with no user params" do
      before do
        post :create, {:user => {}, :format => "json"}
      end

      it { should respond_with(:unprocessable_entity) }
    end
  end
  
  context "PUT to update" do
    before do
      @user = User.create!(:name => "Mike", :email => "test@test.com", :password => "test", :password_confirmation => "test")
      @request.env[API::ApplicationController::API_HEADER_KEY] = @user.api_key
      put :update, {:user => {:name => "Mike", :email => "test2@test.com", :password => "testing", 
                              :password_confirmation => "testing"}, :format => "json"}
    end
    # it { should respond_with(:no_content) }
    # it "should update record" do
    #   User.find_by_email("test2@test.com").try(:authenticate, "testing").should be_an_instance_of(User)
    # end
  end
end
