class Api::V1::Admins::ProgramActivitiesController < ApplicationController
  before_action :require_admin_authentication
  before_action :set_program
  before_action :set_program_activity, except: %i[create index]

  def index
    program_activities = @program.program_activities

    render json: {
      code: 200, 
      status: "success",
      data: program_activities
    }, code: :ok
  end

  def create
    return bulk_create if program_activity_params.is_a?(Array)

    program_activity = @program.program_activities.build(program_activity_params)

    if program_activity.save
      render json: {
				code: 201,
				status: "success",
				message: "Program Activity created successfully",
				data: program_activity
			}, status: :created
		else
			render json: {
				code: 422,
				status: "error",
				errors: program_activity.errors.full_messages
			}, status: :unprocessable_entity
    end
  end

  def update
    if @program_activity.update(program_activity_params)
      render json: {
        code: 200,
        status: "success",
        message: "Program Activity updated successful",
        data: @program_activity
      }, status: :ok
    else
      render json: { 
        code: 422,
        status: "error",
        errors: @program_activity.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @program_activity.destroy
      render json: {
        code: 200,
        status: "success",
        data: @program_activity
      }, status: :ok
    else
      render json: {
        code: 422,
        status: "error",
        errors: @program_activity.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def show
    render json: {
      code: 200,
      status: "success",
      message: "Program activity details fetched",
      data: @program_activity
    }, code: :ok
  end

  private

  def bulk_create
    program_activities = @program.program_activities.build(program_activity_params)

    if program_activities.all?(&:valid?)
      program_activities.each(&:save!)

      render json: {
        code: 201,
        status: "success",
        message: "Created all program activities",
        data: program_activities
      }, status: :created
    else
      errors = program_activities.map(&:errors).reject(&:empty?)

      render json: { 
        code: 422,
        status: "error",
        message: "Failed to create program activities",
        errors: errors,
      }, status: :unprocessable_entity
    end
  end

  def set_program
    @program ||= Program.find(params[:program_id])
  end

  def set_program_activity
    @program_activity ||= @program.program_activities.find_by(id: params[:id])

    if @program_activity.nil?
      return render json: {
        code: 404,
        status: "error",
        error: "No program activity found for id #{params[:id]}"
      }, status: :not_found
    end
  end

  def program_activity_params
    if params.require(:program_activity).is_a?(Array)
      params.require(:program_activity).map do |activity|
        activity.permit(:activity_id, :frequency)
      end
    else
      params.require(:program_activity).permit(:activity_id, :frequency, :repetition)
    end
  end
end
