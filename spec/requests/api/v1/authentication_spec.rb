require "rails_helper"

RSpec.describe "API V1 Authentication", type: :request do
  let(:campus) { create(:campus) }

  let(:user) do
    create(
      :user,
      campus: campus,
      email: "auth-test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  describe "POST /api/v1/login" do
    it "logs in with valid credentials and returns a JWT" do
      user

      post api_v1_login_path,
           params: {
             user: {
               email: "auth-test@example.com",
               password: "password123"
             }
           },
           as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["message"]).to eq("Login successful")
      expect(response.parsed_body.dig("user", "email"))
        .to eq("auth-test@example.com")
      expect(response.headers["Authorization"]).to be_present
    end

    it "rejects invalid credentials" do
      user

      post api_v1_login_path,
           params: {
             user: {
               email: "auth-test@example.com",
               password: "wrong-password"
             }
           },
           as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "protected endpoints" do
    it "rejects requests without a JWT" do
      get api_v1_students_path, as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /api/v1/logout" do
    it "logs out and revokes the JWT" do
      user

      post api_v1_login_path,
           params: {
             user: {
               email: "auth-test@example.com",
               password: "password123"
             }
           },
           as: :json

      expect(response).to have_http_status(:ok)
      token = response.headers["Authorization"]

      expect(token).to be_present

      delete api_v1_logout_path,
             headers: { "Authorization" => token },
             as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["message"]).to eq("Logout successful")

      get api_v1_students_path,
          headers: { "Authorization" => token },
          as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
