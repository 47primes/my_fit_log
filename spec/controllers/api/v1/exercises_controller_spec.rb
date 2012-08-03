require "spec_helper"

describe API::V1::ExercisesController do
  before do
    @user = create(:user)
    @squats = create(:squats, user: @user)
  end

  describe "GET to index" do
    before do
      get :index, {api_key: @user.api_key, format: "json"}
    end
    
    it { should respond_with(:success) }
    it { should respond_with_content_type(:json) }
    it { should assign_to(:user).with @user }
    it { should assign_to(:exercises).with @user.exercises }
  end

  describe "GET to show" do
    describe "for a exercise belonging to a user" do
      before do
        get :show, {id: @squats, api_key: @user.api_key, format: "json"}
      end
      
      it { should respond_with(:success) }
      it { should respond_with_content_type(:json) }
      it { should assign_to(:user).with @user }
      it { should assign_to(:exercise).with @squats }
    end
    
    describe "when the exercise cannot be found" do
      before do
        exercise = create(:exercise)
        get :show, {id: 242442, api_key: @user.api_key, format: "json"}
      end
      
      it { should respond_with(:not_found) }
      it { should assign_to(:user).with @user }
      it { should assign_to(:exercise).with nil }
    end
  end

  describe "POST to create" do
    describe "for a valid post" do
      before do
        post :create, {exercise: {name: "Burpee", instructions: "Squat thrusts!"}, api_key: @user.api_key, format: "json"}
      end
    
      it { should respond_with(:created) }
      it { should respond_with_content_type(:json) }
      it { should assign_to(:exercise).with assigns(:exercise) }
      it { should respond_with_location user_exercise_url(assigns(:exercise)) }
    end
    
    describe "for an invalid post" do
      before do
        post :create, {exercise: {}, api_key: @user.api_key, format: "json"}
      end
    
      it { should respond_with(:unprocessable_entity) }
      it { should respond_with_content_type(:json) }
      it { @response.location.should be_nil }
    end
  end

  describe "PUT to update" do
    describe "for a valid update" do
      before do
        put :update, {id: @squats, exercise: {instructions: "Bend over and stand up."}, 
                      api_key: @user.api_key, format: "json"}
      end
    
      it { should respond_with(:no_content) }
      it { should respond_with_content_type(:json) }
      it { should assign_to(:user).with(@user) }
      it("should update instructions") { @squats.reload.instructions.should == "Bend over and stand up." } 
    end
    
    describe "for an invalid update" do
      before do
        put :update, {id: @squats, exercise: {name: ""}, api_key: @user.api_key, format: "json"}
      end
    
      it { should respond_with(:unprocessable_entity) }
      it { should respond_with_content_type(:json) }
      it { should assign_to(:user).with(@user) }
    end
  end
  
  describe "DELETE to destroy" do
    before do
      delete :destroy, {id: @squats, api_key: @user.api_key, format: "json"}
    end
    
    it { should respond_with(:no_content) }
    it { should assign_to(:user).with(@user) }
    it("should delete the exercise") { Exercise.find_by_id(@squats.id).should be_nil }
  end
end
