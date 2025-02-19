require "rails_helper"

RSpec.describe "Api::V1::Admins::Activities", type: :request do
  let!(:admin) { create(:admin) }
  let(:cookies) { login_as(:admin, admin.email_address, admin.password) }
  let(:valid_params) do
    {
      activity: {
        name: "demo",
        description: "desc",
        frequency: Activity.frequencies[:daily],
        category: Activity.categories[:exercise],
        repetition: 1,
      }
    }
  end

  describe "GET /api/v1/admins/activities" do
    it "returns all activities for the current admin" do
      get "/api/v1/admins/activities", headers: cookies
      (1..3).each do |i|
        create(:activity, admin_id: admin.id, name: "name #{i}")
      end

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "POST /api/v1/admins/activities" do
    it "creates a new activity" do
      post "/api/v1/admins/activities", params: valid_params, headers: cookies
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:created)
      expect(json_response["data"]["category"]).to eq("exercise")
    end
  end

  describe "PATCH /api/v1/admins/activities/:id" do
    let(:activity) { create(:activity) }
    let(:update_params) { { activity: { repetition: 3, frequency: Activity.frequencies[:weekly] } } }

    it "updates the activity" do
      patch "/api/v1/admins/activities/#{activity.id}", params: update_params, headers: cookies

      expect(response).to have_http_status(:ok)
      expect(activity.reload.repetition).to eq(3)
      expect(activity.reload.frequency).to eq("weekly")
    end
  end

  describe "DELETE /api/v1/admins/activities/:id" do
    it "deletes the activity" do
      activity = create(:activity, admin_id: admin.id)

      expect {
        delete "/api/v1/admins/activities/#{activity.id}", headers: cookies
      }.to change{ Activity.count }.by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
