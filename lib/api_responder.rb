# Override the default Api behavior
class ApiResponder < ActionController::Responder
  
  # For nil resources (from which Model.find_by_id returns nil), respond with a 404 status code.
  # When creating a resources, just send a 201 status code and location.
  def api_behavior(error)
    raise error if !resource.nil? && !resourceful?
    
    if resource.nil?
      head :not_found
    elsif get?
      display resource
    elsif post?
      head :created, location: api_location
    else
      head :no_content
    end
  end
  
end
