class Api::V1::UserActivitiesController < ApplicationController
  before_action :require_user_authentication
  before_action :set_user
  before_action :set_program

  def create
    user_activity = @program.user_activities.build(user_activity_params)

    binding.break

    if user_activity.save

      binding.break 
      
      render json: {
        code: 201,
        status: "success",
        message: "Task marked as completed"
      }, status: :created
    else
      remder json: {
        code: 422,
        status: "error",
        error: "failed to mark task completed"
      }, status: :unprocessable_entity
    end
  end

  private
  
  def set_program
    @program ||= Program.find_by(user_id: @user.id, id: params[:program_id])

    unless @program.present?
      return render json: {
        code: 404,
        status: "error",
        error: "Program not found"
      }, status: :not_found
    end
  end

  def set_user
    @user ||= Current.session.resource
  end

  def user_activity_params
    params.require(:user_activity).permit(:activity_id)
  end
end 
