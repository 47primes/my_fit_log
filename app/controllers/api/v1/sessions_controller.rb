class Api::V1::SessionsController < Api::V1::ApplicationController
  
  def create
    @user = User.find_by_email(params[:email]).try(:authenticate, params[:password])
    head :unauthorized unless @user
  end
  
end
