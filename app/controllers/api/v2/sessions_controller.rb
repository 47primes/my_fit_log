class Api::V2::SessionsController < Api::V2::ApplicationController
  
  def create
    @user = authenticate_with_http_basic { |email, password| User.find_by_email(email).try(:authenticate, password) }
	  head :unauthorized unless @user
  end
  
end
