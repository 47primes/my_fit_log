require "spec_helper"

describe API::V2::WorkoutsController do
  before do
    @request.env["Accept"] = "application/vnd.my_fit_log.v2"
    @request.env[API::ApplicationController::DEVICE_HEADER_KEY] = "MyFitLog iOS"
    @request.env["Content-Type"] = "application/json"
    
    @user = create(:user_with_workouts)
    @request.env[API::ApplicationController::API_HEADER_KEY] = @user.reload.api_key
  end
  
  describe "GET to index" do
    describe "with no sorting or pagination" do
      before do
        get :index, {format: "json"}
      end
    
      it { should respond_with(:success) }
      it { should respond_with_content_type(:json) }
      it { should assign_to(:user).with @user }
      it { should assign_to(:workouts).with @user.workouts }
    end
  end

  describe "GET to show" do
    describe "for a workout belonging to a user" do
      before do
        get :show, {id: @user.workouts.first, format: "json"}
      end
      
      it { should respond_with(:success) }
      it { should respond_with_content_type(:json) }
      it { should assign_to(:user).with @user }
      it { should assign_to(:workout).with @user.workouts.first }
    end
    
    describe "when the workout cannot be found" do
      before do
        workout = create(:workout)
        get :show, {id: workout.id, format: "json"}
      end
      
      it { should respond_with(:not_found) }
      it { should respond_with_content_type(:json) }
      it { should assign_to(:user).with @user }
      it { should assign_to(:workout).with nil }
    end
  end
  
  describe "POST to create" do
    describe "for a valid post" do
      before do
        post :create, {workout: {completed_at: Time.now, summary: "Personal best time in the 800."}, format: "json"}
      end
    
      it { should respond_with(:created) }
      it { should respond_with_content_type(:json) }
      it { should assign_to(:workout).with assigns(:workout) }
      it { should respond_with_location(v2_user_workout_url(assigns(:workout))) }
    end
    
    describe "for an invalid post" do
      before do
        post :create, {workout: {}, format: "json"}
      end
    
      it { should respond_with(:unprocessable_entity) }
      it { should respond_with_content_type(:json) }
      it { @response.location.should be_nil }
    end
  end
  
  describe "PUT to update" do
    describe "for a valid update" do
      before do
        @workout = create(:workout, user: @user)
        put :update, {id: @workout.id, :workout => {summary: "Increased my max on bench by 15 lbs."}, format: "json"}
      end
    
      it { should respond_with(:no_content) }
      it { should respond_with_content_type(:json) }
      it { should assign_to(:user).with(@user) }
      it("should update summary") { @workout.reload.summary.should == "Increased my max on bench by 15 lbs." } 
    end
    
    describe "for an invalid update" do
      before do
        workout = create(:workout, user: @user)
        put :update, {id: workout.id, :workout => {completed_at: ""}, format: "json"}
      end
    
      it { should respond_with(:unprocessable_entity) }
      it { should respond_with_content_type(:json) }
      it { should assign_to(:user).with(@user) }
    end
  end
  
  describe "DELETE to destroy" do
    before do
      @workout = @user.workouts.first
      delete :destroy, {id: @workout.id, format: "json"}
    end
    
    it { should respond_with(:no_content) }
    it { should respond_with_content_type(:json) }
    it { should assign_to(:user).with(@user) }
    it("should delete the workout") { Workout.find_by_id(@workout.id).should be_nil }
  end
end
