require 'spec_helper'

describe Api::V1::SessionsController,"#create" do
  before do
    @user = User.create!(:name => "Mike Bradford", :email => "test@test.com", :password => "test", :password_confirmation => "test")
  end
  
  describe "with valid login credentials" do
    before do
      post :create, {:email => @user.email, :password => "test", :format => "json"}
    end
    
    it { should respond_with(:success) }
    it { should respond_with_content_type(:json)  }
    it { should assign_to(:user).with(@user) }
  end
  
  describe "with invalid email" do
    before do
      post :create, {:email => "invalid@test.com", :password => @user.password, :format => "json"}
    end
    
    it { should respond_with(:unauthorized) }
    it { should respond_with_content_type(:json) }
    it { should assign_to(:user).with(nil) }
  end
  
  describe "with a wrong password" do
    before do
      post :create, {:email => @user.email, :password => "wrong", :format => "json"}
    end
    
    it { should respond_with(:unauthorized) }
    it { should respond_with_content_type(:json)  }
    it { should assign_to(:user).with(false) }
  end
end
