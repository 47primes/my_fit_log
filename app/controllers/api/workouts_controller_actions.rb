module API::WorkoutsControllerActions
  def self.included(klass)
    klass.class_eval do
      before_filter :validate_api_key
    end
  end

  def index
    respond_with @user.workouts.order("#{params[:sort_by]} #{params[:sort_direction]}").page(params[:page])
  end

  def show
    respond_with @user.workouts.find(params[:id])
  end

  def create
    respond_with @user.workouts.create(params[:workout])
  end

  def update
    respond_with @user.workouts.update(params[:id], params[:workout])
  end

  def destroy
    respond_with @user.workouts.destroy(params[:id])
  end
end
