
require "rails_helper"

RSpec.describe "API V1 Teachers", type: :request do
  let(:campus) { create(:campus) }
  let(:admin) do
    create(:user, campus: campus, role: "admin")
  end
  let(:teacher) do
    create(:user, campus: campus, role: "teacher")
  end

  def login_and_get_token(user)
    post api_v1_login_path,
         params: {
           user: {
             email: user.email,
             password: "password123"
           }
         },
         as: :json

    response.headers["Authorization"]
  end

  def auth_headers(token)
    { "Authorization" => token }
  end

  describe "POST /api/v1/teachers" do
    it "allows an admin to create a teacher in their campus" do
      token = login_and_get_token(admin)

      expect {
        post api_v1_teachers_path,
             params: {
               user: {
                 email: "newteacher@example.com",
                 password: "password123",
                 password_confirmation: "password123"
               }
             },
             headers: auth_headers(token),
             as: :json
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.parsed_body.dig("teacher", "role")).to eq("teacher")
      expect(response.parsed_body.dig("teacher", "campus_id")).to eq(campus.id)
    end

    it "forbids a teacher from creating another teacher" do
      token = login_and_get_token(teacher)

      expect {
        post api_v1_teachers_path,
             params: {
               user: {
                 email: "blockedteacher@example.com",
                 password: "password123",
                 password_confirmation: "password123"
               }
             },
             headers: auth_headers(token),
             as: :json
      }.not_to change(User, :count)

      expect(response).to have_http_status(:forbidden)
    end

    it "rejects requests without authentication" do
      post api_v1_teachers_path,
           params: {
             user: {
               email: "unauthorized@example.com",
               password: "password123",
               password_confirmation: "password123"
             }
           },
           as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
