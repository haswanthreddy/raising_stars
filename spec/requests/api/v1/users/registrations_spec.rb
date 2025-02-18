require "rails_helper"

RSpec.describe Api::V1::Users::RegistrationsController, type: :request do
    let(:valid_params) do
        {
            user: {
              full_name: "haswanth reddy",
              email_address: "h@h.com",
              password: "password123",
            },
          }
    end

    describe "POST /api/v1/users/sign_up" do
        context "with valid params" do
          before do
            post "/api/v1/users/sign_up", params: valid_params, as: :json
          end
      
          it "creates a new user and returns success response with session cookie" do
            json_response = JSON.parse(response.body)
      
            expect(response).to have_http_status(:created)
            expect(json_response["code"]).to eq(201)
            expect(json_response["message"]).to eq("User registered successfully!")
          end
      
          it "returns session information in response headers" do
            expect(response.headers["Set-Cookie"]).to be_present
          end
        end
      end
end