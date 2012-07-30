module API::RoutinesControllerActions
  def self.included(klass)
    klass.class_eval do
      before_filter :validate_api_key
    end
  end
  
  def index
    respond_with workout.routines
  end

  def show
    respond_with workout.routines.find(params[:id])
  end

  def create
    respond_with workout.routines.create(params[:routine])
  end

  def update
    respond_with workout.routines.update(params[:id], params[:routine])
  end

  def destroy
    respond_with workout.routines.destroy(params[:id])
  end
  
  protected
  
  def workout
    @workout ||= @user.workouts.find(params[:workout_id])
  end
end
