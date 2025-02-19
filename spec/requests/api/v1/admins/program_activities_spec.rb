require "rails_helper"

RSpec.describe "Api::V1::Admins::ProgramActivities", type: :request do
  let(:admin) { create(:admin) }
  let(:cookies) { login_as(:admin, admin.email_address, admin.password) }
  let(:program) { create(:program) }
  let(:activity) { create(:activity) }
  let(:activity_2) { create(:activity, name: "activity 2") }
  let(:program_activity_params_single) { 
    {
      "program_activity": 
        { "activity_id": activity.id, "frequency": "daily", repetition: 1 },
    }
   }
   let(:program_activity_params_multiple) {
      {
        "program_activity": [
          { "activity_id": activity.id, "frequency": "daily" },
          { "activity_id": activity_2.id, "frequency": "weekly" }
        ]
      }
   }

  describe "GET /api/v1/admins/programs/:program_id/program_activities" do
    it "returns all activities for the current admin" do
      (1..3).each do |i|
        activity = create(:activity, name: "activity #{i+1}")
        create(:program_activity, program_id: program.id, activity_id: activity.id)
      end

      get "/api/v1/admins/programs/#{program.id}/program_activities", headers: cookies

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "GET /api/v1/admins/programs/:program_id/program_activities/:id" do
    it "returns specific program activity of provided id" do
      program_activity = create(:program_activity, program: program, activity: activity)

      get "/api/v1/admins/programs/#{program.id}/program_activities/#{program_activity.id}", headers: cookies

      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json_response["data"]["id"]).to eq(program_activity.id)
      expect(json_response["data"]["activity_id"]).to eq(program_activity.activity_id)
      expect(json_response["data"]["program_id"]).to eq(program_activity.program_id)
    end
  end

  describe "POST /api/v1/admins/programs/:program_id/program_activities/" do
    context "for creating only one program_activity at once" do
      it "creates a new program activity" do
        post "/api/v1/admins/programs/#{program.id}/program_activities/", headers: cookies, params: program_activity_params_single
  
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(json_response["data"]["frequency"]).to eq("daily")
      end
    end

    context "for creating multiple program_activities at once" do
      it "create multiple new program activity" do
        post "/api/v1/admins/programs/#{program.id}/program_activities/", headers: cookies, params: program_activity_params_multiple

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(json_response["data"].size).to eq(2)
      end
    end 
  end


  describe "DELETE /api/v1/admins/program/:program_id/program_activities/:id" do
    it "deletes the program_activity" do
      program_activity = create(:program_activity, activity_id: activity.id, program_id: program.id)

      expect {
        delete "/api/v1/admins/programs/#{program.id}/program_activities/#{program_activity.id}", headers: cookies
      }.to change{ ProgramActivity.count }.by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end