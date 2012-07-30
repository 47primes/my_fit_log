class API::V1::SessionsController < API::V1::ApplicationController
  
  def create
    if @user = User.find_by_email(params[:email]).try(:authenticate, params[:password])
      response.location = user_url(@user)
    else
      response.status = :unprocessable_entity
    end
  end
  
end
