module CampusFlow
  module Api
    module V1
      class TeachersController < ApplicationController
        before_action :authenticate_user!
        before_action :require_admin!

        def create
          teacher = current_user.campus.users.new(teacher_params)
          teacher.role = "teacher"

          if teacher.save
            render json: {
              message: "Teacher created successfully",
              teacher: {
                id: teacher.id,
                email: teacher.email,
                role: teacher.role,
                campus_id: teacher.campus_id
              }
            }, status: :created
          else
            render json: {
              errors: teacher.errors.full_messages
            }, status: :unprocessable_content
          end
        end

        private

        def require_admin!
          return if current_user&.admin?

          render json: {
            error: "Only admins can create teachers"
          }, status: :forbidden
        end

        def teacher_params
          params.require(:user).permit(
            :email,
            :password,
            :password_confirmation
          )
        end
      end
    end
  end
end
