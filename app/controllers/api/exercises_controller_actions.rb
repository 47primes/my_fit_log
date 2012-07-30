module API::ExercisesControllerActions
  def self.included(klass)
    klass.class_eval do
      before_filter :validate_api_key
    end
  end
  
  def index
    respond_with @user.exercises
  end

  def show
    respond_with @user.exercises.find(params[:id])
  end

  def create
    respond_with @user.exercises.create(params[:exercise])
  end

  def update
    respond_with @user.exercises.update(params[:id], params[:exercise])
  end

  def destroy
    respond_with @user.exercises.destroy(params[:id])
  end
end
