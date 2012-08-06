module Api::ExercisesControllerActions
  def self.included(klass)
    klass.class_eval do
      before_filter :validate_api_key
      before_filter :find_exercise, only: [:show, :update, :destroy]
    end
  end
  
  def index
    @exercises = @user.exercises.page(params[:page])
    respond_with @exercises
  end

  def show
    respond_with @exercise, responder: ApiResponder
  end

  def create
    @exercise = @user.exercises.create(params[:exercise])
    respond_with @exercise, responder: ApiResponder, location: (user_exercise_url(@exercise) if @exercise.valid?) 
  end

  def update
    @exercise.update_attributes(params[:exercise]) if @exercise
    respond_with @exercise, responder: ApiResponder
  end

  def destroy
    @exercise.destroy if @exercise
    respond_with @exercise, responder: ApiResponder
  end

  protected

  def find_exercise
    @exercise = @user.exercises.find_by_id(params[:id]) or head(:not_found) and return
  end
end
