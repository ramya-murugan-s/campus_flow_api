require "rails_helper"

RSpec.describe "API V1 Students", type: :request do
  let(:campus) { create(:campus) }
  let(:user) { create(:user, campus: campus, role: "teacher") }
  let(:token) { login_and_get_token(user) }

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

  describe "GET /api/v1/students" do
    it "returns students belonging to the user's campus" do
      student = create(:student, campus: campus)
      create(:student, campus: create(:campus), email: "other@example.com")

      get api_v1_students_path,
          headers: auth_headers(token),
          as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.map { |item| item["id"] })
        .to include(student.id)
      expect(response.parsed_body.map { |item| item["email"] })
        .not_to include("other@example.com")
    end
  end

  describe "POST /api/v1/students" do
    it "creates a student in the user's campus" do
      expect {
        post api_v1_students_path,
             params: {
               student: {
                 name: "Priya Kumar",
                 email: "priya@example.com",
                 date_of_birth: "2006-04-12"
               }
             },
             headers: auth_headers(token),
             as: :json
      }.to change(Student, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.parsed_body["campus_id"]).to eq(campus.id)
    end

    it "rejects invalid student data" do
      post api_v1_students_path,
           params: {
             student: {
               name: "",
               email: "invalid-email",
               date_of_birth: "2006-04-12"
             }
           },
           headers: auth_headers(token),
           as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body["errors"]).to be_present
    end
  end

  describe "GET /api/v1/students/:id" do
    it "returns a student from the user's campus" do
      student = create(:student, campus: campus)

      get "/api/v1/students/#{student.id}",
          headers: auth_headers(token),
          as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["id"]).to eq(student.id)
    end

    it "does not expose another campus's student" do
      other_student = create(
        :student,
        campus: create(:campus),
        email: "private@example.com"
      )

      get "/api/v1/students/#{other_student.id}",
          headers: auth_headers(token),
          as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /api/v1/students/:id" do
    it "updates a student in the user's campus" do
      student = create(:student, campus: campus)

      patch "/api/v1/students/#{student.id}",
            params: { student: { name: "Updated Student" } },
            headers: auth_headers(token),
            as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["name"]).to eq("Updated Student")
    end
  end

  describe "DELETE /api/v1/students/:id" do
    it "forbids a teacher from deleting a student" do
      student = create(:student, campus: campus)

      expect {
        delete "/api/v1/students/#{student.id}",
               headers: auth_headers(token),
               as: :json
      }.not_to change(Student, :count)

      expect(response).to have_http_status(:forbidden)
    end

    it "allows an admin to delete a student in their campus" do
      admin = create(:user, campus: campus, role: "admin")
      admin_token = login_and_get_token(admin)
      student = create(:student, campus: campus)

      expect {
        delete "/api/v1/students/#{student.id}",
               headers: auth_headers(admin_token),
               as: :json
      }.to change(Student, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
