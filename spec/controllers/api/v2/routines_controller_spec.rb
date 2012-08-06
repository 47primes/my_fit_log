require "spec_helper"

describe API::V2::RoutinesController do
  before do
    @request.env["Accept"] = "application/vnd.my_fit_log.v2"
    @request.env[API::ApplicationController::USER_AGENT_HEADER_KEY] = "MyFitLog iOS"
    @request.env["Content-Type"] = "application/json"
    @user = create(:user_with_routines)
    @request.env[API::ApplicationController::API_HEADER_KEY] = @user.reload.api_key
    @workout = @user.workouts.first
    @routine = @workout.routines.first
  end
  
  describe "GET to index" do
    describe "with no pagination" do
      before do
        get :index, {workout_id: @workout, format: "json"}
      end
    
      it { should respond_with(:success) }
      it { should respond_with_content_type(:json) }
      it { should assign_to(:workout).with @workout }
      it { should assign_to(:routines).with @workout.routines }
    end
  end

  describe "GET to show" do
    describe "for a routine belonging to a user's workout" do
      before do
        get :show, {id: @routine, workout_id: @workout, format: "json"}
      end
      
      it { should respond_with(:success) }
      it { should respond_with_content_type(:json) }
      it { should assign_to(:workout).with @workout }
      it { should assign_to(:routine).with @routine }
    end
    
    describe "when the routine cannot be found" do
      before do
        routine = create(:routine)
        get :show, {id: routine, workout_id: routine.workout, format: "json"}
      end
      
      it { should respond_with(:not_found) }
      it { should assign_to(:workout).with nil }
    end
  end
  
  describe "POST to create" do
    describe "for a valid post" do
      before do
        post :create, {routine: {exercise_id: create(:bench_press), sets: 5, reps: 12}, workout_id: @workout, format: "json"}
      end
    
      it { should respond_with(:created) }
      it { should respond_with_content_type(:json) }
      it { should respond_with_location user_workout_routine_url assigns(:workout), assigns(:routine) }
    end
  end
  
  describe "PUT to update" do
    describe "for a valid update" do
      before do
        put :update, {id: @routine, routine: {distance: 20}, workout_id: @workout, format: "json"}
      end
    
      it { should respond_with(:no_content) }
      it { should respond_with_content_type(:json) }
      it("should update distance") { @routine.reload.distance.should == "20" } 
    end
  end
  
  describe "DELETE to destroy" do
    before do
      delete :destroy, {id: @routine, workout_id: @workout, format: "json"}
    end
    
    it { should respond_with(:no_content) }
    it("should delete the routine") { Routine.find_by_id(@routine.id).should be_nil }
  end
end
