class API::V1::ApplicationController < API::ApplicationController
  
  protected

  def validate_api_key
    @user = User.find_by_auth_key(params[:api_key])
    return head(:unauthorized) if @user.nil?
  end
end
