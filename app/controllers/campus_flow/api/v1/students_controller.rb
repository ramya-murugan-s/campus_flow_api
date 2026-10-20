
module CampusFlow
  module Api
    module V1
      class StudentsController < ApplicationController
        before_action :authenticate_user!
        before_action :set_student, only: %i[show update destroy]
        before_action :require_admin!, only: :destroy

        def index
          render json: current_user.campus.students
        end

        def show
          render json: @student
        end

        def create
          student = current_user.campus.students.new(student_params)

          if student.save
            render json: student, status: :created
          else
            render json: { errors: student.errors.full_messages },
                   status: :unprocessable_content
          end
        end

        def update
          if @student.update(student_params)
            render json: @student
          else
            render json: { errors: @student.errors.full_messages },
                   status: :unprocessable_content
          end
        end

        def destroy
          @student.destroy!
          head :no_content
        end

        private

        def set_student
          @student = current_user.campus.students.find(params[:id])
        end

        def require_admin!
          return if current_user.admin?

          render json: { error: "Admin access required" },
                 status: :forbidden
        end

        def student_params
          params.require(:student).permit(
            :name, :email, :date_of_birth
          )
        end
      end
    end
  end
end
