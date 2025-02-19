class Api::V1::Admins::ProgramsController < ApplicationController
	before_action :require_admin_authentication
	before_action :set_admin
	before_action :set_program, only: %i[update destroy]

	def create
		program = @current_admin.programs.build(program_params)
	
		if program.save
			render json: {
				code: 201,
				status: "success",
				message: "Program created successfully",
				data: program
			}, status: :created
		else
			render json: {
				code: 422,
				status: "error",
				errors: program.errors.full_messages
			}, status: :unprocessable_entity
		end
	end
	
	  def update
			if @program.update(program_params)
				render json: {
					code: 200,
					status: "success",
					message: "Program updated successful",
					data: @program
				}, status: :ok
			else
				render json: {
          code: 422,
          status: "error",
          errors: @program.errors.full_messages
         }, status: :unprocessable_entity
			end
	  end

	  def destroy
      if @program.update(deleted_at: DateTime.now)
        render json: {
          code: 200,
          status: "success",
          data: @program
        }, status: :ok
      else
        render json: {
          code: 422,
          status: "error",
          errors: @program.errors.full_messages
        }, status: :unprocessable_entity
      end
	  end
	
	  private

	  def set_admin
			@current_admin ||= Current.session.resource
	  end
	
	  def set_program
		@program ||= Program.find_by(id: params[:id])
		
			unless @program.present?
				return render json: {
					code: 404,
					status: "error",
					error: "Program not found"
				}, status: :not_found
			end
	  end
	
	  def program_params
		  params.require(:program).permit(:title, :user_id, :start_date, :end_date, :description)
	  end
end
