require "rails_helper"

RSpec.describe Api::V1::Admins::SessionsController, type: :request do
  let(:admin) { create(:admin) }
  let(:valid_credentials) do
    { email_address: admin.email_address, password: admin.password }
  end
  let(:invalid_credentials) do
    { email_address: admin.email_address, password: "1234567890" }
  end

  describe "POST /api/v1/admins/sign_in" do
    context "with valid credentials" do
      it "logs in the admin and returns JWT token" do
        post "/api/v1/admins/sign_in", params: valid_credentials

        json_response = JSON.parse(response.body)
        code = json_response["code"]
        message = json_response["message"]
        data = json_response["data"]

        expect(response).to have_http_status(:ok)
        expect(code).to eq(200)
        expect(message).to eq("Admin signed in successfully")
        expect(data).to include("full_name" => admin.full_name, "email_address" => admin.email_address)
        expect(response.headers["Set-Cookie"]).to be_present
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized error" do
        post "/api/v1/admins/sign_in", params: invalid_credentials

        json_response = JSON.parse(response.body)


        expect(response).to have_http_status(:unauthorized)
        expect(json_response["status"]).to eq("error")
      end
    end
  end

  describe "DELETE /api/v1/admins/sign_out" do
    context "when admin is signed in" do
      it "signs out the admin successfully" do
        post "/api/v1/admins/sign_in", params: valid_credentials, as: :json
        expect(response).to have_http_status(:ok)
  
        delete "/api/v1/admins/sign_out"
  
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Admin Logged out successfully!")
      end
    end
  
    context "when no admin is signed in" do
      it "returns an unauthorized error" do
        delete "/api/v1/admins/sign_out"
  
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Unauthorized access")
      end
    end
  end
end