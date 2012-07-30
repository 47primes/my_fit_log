require 'spec_helper'

describe API::V2::SessionsController,"#create" do
  before do
    @user = User.create!(:name => "Mike Bradford", :email => "test@test.com", :password => "test", :password_confirmation => "test")
    @request.env["Accept"] = "application/vnd.my_fit_log.v2"
    @request.env[API::ApplicationController::DEVICE_HEADER_KEY] = "MyFitLog iOS"
    @request.env["Content-Type"] = "application/json"
  end
  
  context "with valid login credentials" do
    before do
      @request.env["HTTP_AUTHORIZATION"] = "Basic #{Base64::encode64("#{@user.email}:#{@user.password}")}"
      post :create, {:format => "json"}
    end
    
    it { should respond_with(:success) }
    it { should respond_with_content_type(:json)  }
    it { should assign_to(:user).with(@user) }
    it { @controller.response.location.should == user_url(@user)  }
  end
  
  context "with an invalid email" do
    before do
      @request.env["HTTP_AUTHORIZATION"] = "Basic #{Base64::encode64("invalid@test.com:#{@user.password}")}"
      post :create, {:format => "json"}
    end
    
    it { should respond_with(:unprocessable_entity) }
    it { should respond_with_content_type(:json)  }
    it { should assign_to(:user).with(nil) }
  end
    
  context "with a wrong password" do
    before do
      @request.env["HTTP_AUTHORIZATION"] = "Basic #{Base64::encode64("#{@user.email}:wrong")}"
      post :create, {:format => "json"}
    end
    
    it { should respond_with(:unprocessable_entity) }
    it { should respond_with_content_type(:json)  }
    it { should assign_to(:user).with(false) }
  end
end
