class API::V2::SessionsController < API::V2::ApplicationController
  
  def create
    if @user = authenticate_with_http_basic { |email, password| User.find_by_email(email).try(:authenticate, password) }
      head :created, location: @user.api_key
		else
		  head :unauthorized
	  end
  end
  
end
