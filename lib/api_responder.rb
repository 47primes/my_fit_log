# Override the default Api behavior
class ApiResponder < ActionController::Responder
  
  # When creating a resources, just send a 201 status code and location.
  def api_behavior(error)
    raise unless resourceful?
    
    if get?
      display resource
    elsif post?
      head :created, location: api_location
    else
      head :no_content
    end
  end
  
end
