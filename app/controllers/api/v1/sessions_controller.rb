class Api::V1::SessionsController < Api::V1::ApplicationController
  
  def create
    if @user = User.find_by_email(params[:email]).try(:authenticate, params[:password])
      head :created, location: @user.api_key
    else
      head :unauthorized
    end
  end
  
end
