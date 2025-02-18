require "rails_helper"

RSpec.describe Admin, type: :model do
  describe "Associations" do
    context "session associations" do    
      it { is_expected.to have_many(:sessions) }

      it "destroys sessions when admin is destroyed" do
        admin = create(:admin)
        (1..5).map { create(:session, :for_admin, resource: admin) }

        expect(admin.sessions.size).to eq(5)

        admin.destroy
        
        expect(admin.sessions).to be_empty
      end
    end
  end

  describe "has_secure_password" do
    let(:admin) { create(:admin, password: "password123") }

    it "encrypts the password" do
      expect(admin.password_digest).to_not be_nil
      expect(admin.authenticate("password123")).to eq(admin)
      expect(admin.authenticate("wrong_password")).to be_falsey
    end

    it "adds password and password_confirmation attributes" do
      expect(admin).to respond_to(:password)
      expect(admin).to respond_to(:password_confirmation)
    end
  end

  describe "normalizes email_address" do
    it "strips and downcases the email address" do
      admin = create(:admin, email_address: "  TEST@EXAMPLE.COM  ")
      expect(admin.email_address).to eq("test@example.com")
    end

    it "normalizes on update" do
      admin = create(:admin, email_address: "  TEST@EXAMPLE.COM  ")
      admin.update(email_address: "  ANOTHER@EXAMPLE.COM  ")
      expect(admin.email_address).to eq("another@example.com")
    end
  end
end
