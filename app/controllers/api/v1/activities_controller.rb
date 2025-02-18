class Api::V1::ActivitiesController < ApplicationController
	before_action :require_admin_authentication
	before_action :set_admin, only: %i[update destroy]
	before_action :set_activity, only: %i[update destroy]

	def index
		activities = Activity.all

		render json: {
			code: 200,
			status: "success",
			data: activities,
		}, status: :ok
	end

	def create
		activity = @current_admin.activities.build(activity_params)
	
		if activity.save
			render json: {
				code: 201,
				status: "success",
				message: "Activity created successfully",
				data: activity
			}, status: :created
		else
			render json: {
				code: 422,
				status: "error",
				errors: activity.errors.full_messages
			}, status: :unprocessable_entity
		end
	end
	
	  def update
			if @activity.update(activity_params)
				render json: {
					code: 200,
					status: "success",
					message: "updated successful",
					data: @activity
				}, status: :ok
			else
				render json: { errors: @activity.errors.full_messages }, status: :unprocessable_entity
			end
	  end

	  def destroy
			@activity.destroy
			
			render json: {
				code: 200,
				status: "success",
				message: "activity deleted"
			}, status: :ok
	  end
	
	  private

	  def set_admin
			@current_admin ||= Current.session.resource
	  end
	
	  def set_activity
		@activity ||= @current_admin.activities.find_by(id: params[:id])
		
			unless @activity.present?
				return render json: {
					code: 404,
					status: "error",
					error: "Activity not found"
				}, status: :not_found
			end
	  end
	
	  def activity_params
		params.require(:activity).permit(:name, :frequency, :category, :repetition, :description)
	  end
end
