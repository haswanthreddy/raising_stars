require "rails_helper"

RSpec.describe User, type: :model do
  describe "Associations" do
    context "session associations" do    
      it { is_expected.to have_many(:sessions) }

      it "destroys sessions when user is destroyed" do
        user = create(:user)

        (1..5).map { create(:session, :for_user, resource: user) }

        expect(user.sessions.size).to eq(5)

        user.destroy
        
        expect(user.sessions).to be_empty
      end
    end
  end

  describe "has_secure_password" do
    let(:user) { create(:user, password: "password123") }

    it "encrypts the password" do
      expect(user.password_digest).to_not be_nil
      expect(user.authenticate("password123")).to eq(user)
      expect(user.authenticate("wrong_password")).to be_falsey
    end

    it "adds password and password_confirmation attributes" do
      expect(user).to respond_to(:password)
      expect(user).to respond_to(:password_confirmation)
    end
  end

  describe "normalizes email_address" do
    it "strips and downcases the email address" do
      user = create(:user, email_address: "  TEST@EXAMPLE.COM  ")
      expect(user.email_address).to eq("test@example.com")
    end

    it "normalizes on update" do
      user = create(:user, email_address: "  TEST@EXAMPLE.COM  ")
      user.update(email_address: "  ANOTHER@EXAMPLE.COM  ")
      expect(user.email_address).to eq("another@example.com")
    end
  end
end
