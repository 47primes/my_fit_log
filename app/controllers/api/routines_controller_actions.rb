module API::RoutinesControllerActions
  def self.included(klass)
    klass.class_eval do
      before_filter :validate_api_key
      before_filter :find_workout
      before_filter :find_routine, only: [:show, :update, :destroy]
    end
  end
  
  def index
    @routines = @workout.routines.page(params[:page])
    respond_with @routines
  end

  def show
    respond_with @routine, responder: APIResponder
  end

  def create
    @routine = @workout.routines.create(params[:routine])
    respond_with @routine, responder: APIResponder, location: (user_workout_routine_url(@workout, @routine) if @routine.valid?)
  end

  def update
    @routine.update_attributes(params[:routine]) if @routine
    respond_with @routine, responder: APIResponder
  end

  def destroy
    @routine.destroy if @routine
    respond_with @routine, responder: APIResponder
  end

  protected

  def find_workout
    @workout = @user.workouts.find_by_id(params[:workout_id]) or head(:not_found) and return
  end

  def find_routine
    @routine = @workout.routines.find_by_id(params[:id]) or head(:not_found) and return
  end

end
