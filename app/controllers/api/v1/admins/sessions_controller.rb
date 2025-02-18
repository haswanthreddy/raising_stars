class Api::V1::Admins::SessionsController < ApplicationController
  before_action :require_admin_authentication, only: %i[destroy]

  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { 
    render json: {
      code: 429,
      status: "error",
      message: "Too many requests. Try again later"
    }, status: :too_many_requests
  }

  def create
    if admin = Admin.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for(admin)
      
      render json: {
        code: 200,
        status: "success",
        message: "Admin signed in successfully",
        data: {
          full_name: admin.full_name,
          email_address: admin.email_address
        }
      }, status: :ok
    else
      render json: {
        code: 401,
        status: "error",
        message: "Invalid email and password",
      }, status: :unauthorized
    end
  end

  def destroy
    terminate_session
    
    render json: {
      code: 200,
      status: "success",
      message: "Admin Logged out successfully!"
    }, status: :ok
  end
end
  