require 'rails_helper'

RSpec.describe "Api::V1::Admins::Program", type: :request do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let(:cookies) { login_as(:admin, admin.email_address, admin.password) }
  let(:valid_params) do
    {
      program: {
        title: "demo",
        admin_id: admin.id,
        user_id: user.id,
        start_date: Date.today - 10.days,
        end_date: Date.today + 80.days,
        repetition: 1
      }
    }
  end

  describe "POST /api/v1/admins/programs" do
    it "creates a new programs" do
      post "/api/v1/admins/programs", params: valid_params, headers: cookies

      json_response = JSON.parse(response.body)


      expect(response).to have_http_status(:created)
      expect(json_response["data"]["title"]).to eq("demo")
      expect(json_response["data"]["user_id"]).to eq(user.id)
      expect(json_response["data"]["admin_id"]).to eq(admin.id)
      expect(json_response["data"]["start_date"].to_date).to eq(valid_params[:program][:start_date].to_date)


      expect(json_response["data"]["end_date"].to_date).to eq(valid_params[:program][:end_date].to_date)
    end
  end

  describe "PATCH /api/v1/admins/programs/:id" do
    let(:program) { create(:program) }
    let(:update_params) { { program: { title: "new title", start_date: Date.today + 5.days } } }

    it "updates the programs" do
      patch "/api/v1/admins/programs/#{program.id}", params: update_params, headers: cookies

      expect(response).to have_http_status(:ok)
      expect(program.reload.title).to eq("new title")
      expect(program.reload.start_date.to_date).to eq((Date.today + 5.days).to_date)
    end
  end

  describe "DELETE /api/v1/admins/programs/:id" do
    it "deletes the programs" do
      program = create(:program, admin_id: admin.id)

      expect(program.deleted_at).to be_nil

      delete "/api/v1/admins/programs/#{program.id}", headers: cookies

      expect(program.reload.deleted_at).not_to be_nil
      expect(response).to have_http_status(:ok)
    end
  end
end
