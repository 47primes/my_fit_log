require "spec_helper"

describe API::V2::UsersController do
  before do
    @request.env["Accept"] = "application/vnd.truth_packer.v2"
    @request.env[API::ApplicationController::USER_AGENT_HEADER_KEY] = "MyFitLog Android"
    @request.env["Content-Type"] = "application/json"
  end
  
  describe "POST to create" do
    describe "with valid attributes" do
      before do
        post :create, {user: {name: "Mike", email: "test@test.com", password: "test", 
                                 password_confirmation: "test"}, format: "json"}
      end

      it { should respond_with(:created) }
      it { should assign_to(:user).with assigns(:user) }
      it { should respond_with_location(assigns(:user).api_key) }
    end

    describe "should fail if email already exists" do 
      before do
        User.create!(name: "Mike", email: "test@test.com", password: "test", password_confirmation: "test")
        post :create, {user: {name: "Mike", email: "test@test.com", password: "testing", 
                                 password_confirmation: "testing"}, format: "json"}
      end

      it { should respond_with(:unprocessable_entity) }
    end

    describe "should fail with invalid email" do
      before do
        post :create, {user: {name: "Mike", email: "test@test", password: "test", 
                                 password_confirmation: "test"}, format: "json"}
      end

      it { should respond_with(:unprocessable_entity) }
    end

    describe "should fail if missing email" do
      before do
        post :create, {user: {name: "Mike", password: "test", password_confirmation: "test"}, format: "json"}
      end

      it { should respond_with(:unprocessable_entity) }
    end

    describe "should fail if missing password" do
      before do
        post :create, {user: {name: "Mike", email: "test@test.com"}, format: "json"}
      end

      it { should respond_with(:unprocessable_entity) }
    end

    describe "should fail with no user params" do
      before do
        post :create, {user: {}, format: "json"}
      end

      it { should respond_with(:unprocessable_entity) }
    end
  end
  
  describe "PUT to update" do
    before do
      @user = create(:user, password: "test")
      @request.env[API::ApplicationController::API_HEADER_KEY] = @user.reload.api_key
      put :update, {user: {password: "testing", password_confirmation: "testing"}, format: "json"}
    end
    it { should respond_with(:no_content) }
    it "should update record" do
      User.find_by_email(@user.email).try(:authenticate, "testing").should be_an_instance_of(User)
    end
  end
end
