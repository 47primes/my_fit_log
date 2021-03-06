module Api::WorkoutsControllerActions
  def self.included(klass)
    klass.class_eval do
      before_filter :validate_api_key
      before_filter :find_workout, only: [:show, :update, :destroy]
    end
  end

  def index
    @workouts = Workout.by_month @user, (params[:month] || Time.now.month), (params[:year] || Time.now.year)
    respond_with @workouts
  end

  def show
    respond_with @workout, responder: ApiResponder
  end

  def create
    @workout = @user.workouts.create(params[:workout])
    respond_with @workout, responder: ApiResponder, location: (user_workout_url(@workout) if @workout.valid?)
  end

  def update
    @workout.update_attributes(params[:workout]) if @workout
    respond_with @workout, responder: ApiResponder
  end

  def destroy
    @workout.destroy if @workout
    respond_with @workout, responder: ApiResponder
  end
  
  protected
  
  def find_workout
    @workout = @user.workouts.find_by_id(params[:id]) or head(:not_found) and return
  end
end
