class Api::V1::Users::SessionsController < ApplicationController
  before_action :require_user_authentication, only: %i[destroy]

  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { 
    render json: {
      code: 429,
      status: "error",
      message: "Too many requests. Try again later"
    }, status: :too_many_requests
  }

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for(user)
      
      render json: {
        code: 200,
        status: "success",
        message: "User signed in successfully",
        data: {
          full_name: user.full_name,
          email_address: user.email_address
        }
      }, status: :ok
    else
      render json: {
        code: 401,
        status: "error",
        message: "Invalid email and password",
        errors: []
      }, status: :unauthorized
    end
  end

  def destroy
    render json: {
      code: 200,
      status: "success",
      message: "User Logged out successfully!",
    }, status: :ok
  end
end
