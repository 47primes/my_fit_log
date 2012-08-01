module API::UsersControllerActions
  def self.included(klass)
    klass.class_eval do
      before_filter :validate_api_key, only: :update
    end
  end
  
  def create
    @user = User.create(params[:user])
    respond_with @user, location: @user.api_key
  end

  def update
    respond_with @user.update_attributes(params[:user])
  end
  
  def reset_password
    User.find_by_email(params[:email]).try(:reset_password)
    head(:no_content)
  end
end
