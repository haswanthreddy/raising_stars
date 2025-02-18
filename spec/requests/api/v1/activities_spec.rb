require 'rails_helper'

RSpec.describe "Api::V1::Activities", type: :request do
  let!(:admin) { create(:admin) }
  let!(:activities) do
    (1..3).each do |i|
      create(:activity, admin_id: admin.id, name: "name #{i}")
    end
  end

  describe "GET /api/v1/activities" do
    it "returns all activities for the current admin" do
      cookies = login_as(:admin, admin.email_address, admin.password)

      get "/api/v1/activities", headers: cookies

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  # describe "POST /api/v1/activities" do
  #   let(:valid_params) { { activity: { frequency: "daily", category: "exercise", repitions: 5 } } }

  #   it "creates a new activity" do
  #     post "/api/v1/activities", params: valid_params, headers: auth_headers(token)

  #     expect(response).to have_http_status(:created)
  #     expect(JSON.parse(response.body)["category"]).to eq("exercise")
  #   end
  # end

  # describe "PATCH /api/v1/activities/:id" do
  #   let(:activity) { activities.first }
  #   let(:update_params) { { activity: { repitions: 10 } } }

  #   it "updates the activity" do
  #     patch "/api/v1/activities/#{activity.id}", params: update_params, headers: auth_headers(token)

  #     expect(response).to have_http_status(:ok)
  #     expect(activity.reload.repitions).to eq(10)
  #   end
  # end

  # describe "DELETE /api/v1/activities/:id" do
  #   let(:activity) { activities.first }

  #   it "deletes the activity" do
  #     expect {
  #       delete "/api/v1/activities/#{activity.id}", headers: auth_headers(token)
  #     }.to change(Activity, :count).by(-1)

  #     expect(response).to have_http_status(:no_content)
  #   end
  # end
end
