class ApplicationController < ActionController::API
  include AbstractController::Helpers
  include ActionController::Cookies
  include Authentication

  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing

  private

  def handle_parameter_missing(exception)
    render json: { error: "Missing parameter: #{exception.param}" }, status: :bad_request
  end
end
