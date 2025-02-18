class Api::V1::Users::RegistrationsController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      start_new_session_for(user)

      render json: {
        status: "success",
        code: 201,
        data: { full_name: user.full_name, email: user.email_address },
        message: "User registered successfully!"
      }, status: :created
    else
      render json: {
        status: "error",
        code: 422, 
        errors: user.errors.full_messages,
        message: "Signup failed!"
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email_address, :password)
  end
end