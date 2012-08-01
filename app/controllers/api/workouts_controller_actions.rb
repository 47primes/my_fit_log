module API::WorkoutsControllerActions
  def self.included(klass)
    klass.class_eval do
      before_filter :validate_api_key
      before_filter :find_workout, only: [:show, :update, :destroy]
    end
  end

  def index
    @workouts = @user.workouts.order("#{params[:sort_by]} #{params[:sort_direction]}").page(params[:page])
    respond_with @workouts
  end

  def show
    respond_with @workout, responder: APIResponder
  end

  def create
    @workout = @user.workouts.create(params[:workout])
    respond_with @workout, responder: APIResponder, location: (v2_user_workout_url(@workout) if @workout.valid?)
  end

  def update
    @workout.update_attributes(params[:workout]) if @workout
    respond_with @workout, responder: APIResponder
  end

  def destroy
    @workout.destroy if @workout
    respond_with @workout, responder: APIResponder
  end
  
  protected
  
  def find_workout
    @workout = @user.workouts.find_by_id(params[:id])
  end
end
