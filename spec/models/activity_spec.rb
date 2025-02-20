require "rails_helper"

RSpec.describe Activity, type: :model do
  describe "Associations" do
    it { should belong_to(:admin).optional }
    it { should have_many(:user_activities) }
    it { should have_many(:program_activities) }
  end

  describe "validations" do
    it { should validate_numericality_of(:repetition).is_greater_than(0) }
    
    it "validates uniqueness of name" do
      activity = create(:activity, name: "Demo Activity")

      duplicate_activity = Activity.new(name: "demo activity", category: "visual", frequency: "daily", repetition: 8)
      expect(duplicate_activity).not_to be_valid
      expect(duplicate_activity.errors[:name]).to include("name has already been taken")
    end
  end

  describe "custom repetition validation" do
    context "when frequency is weekly" do
      it "is invalid if repetition is more than 3" do
        activity = build(:activity, frequency: "weekly", repetition: 4)
       
        expect(activity).not_to be_valid
        expect(activity.errors[:repetition]).to include("must be 3 or less for weekly frequency")
      end

      it "is valid if repetition is less than or equal to 3" do
        activity = build(:activity, frequency: "weekly", repetition: 3)

        expect(activity).to be_valid
      end
    end

    context "when frequency is daily" do
      it "is valid repetition 10 or less" do
        activity = build(:activity, frequency: "daily", repetition: 10)

        expect(activity).to be_valid
      end

      it "is invalid if repetition is more than 10" do
        activity = build(:activity, frequency: "daily", repetition: 11)

        expect(activity).not_to be_valid
      end
    end
  end

  describe "enums" do
    it "defines correct values for frequency enum" do
      expect(Activity.frequencies).to eq({
        "daily" => 0,
        "weekly" => 1
      })
    end

    it "defines correct values for category enum" do
      expect(Activity.categories).to eq({
        "exercise" => 0,
        "stimulation" => 1,
        "cognitive" => 3,
        "visual" => 4,
        "logical" => 5,
        "speaking" => 6,
        "knowledge" => 7,
        "memory" => 8,
        "entertainment" => 9,
        "play" => 11
      })
    end
  end

  describe "dependent behavior" do
    let!(:admin) { create(:admin) }
    let!(:activity) { create(:activity, admin: admin) }

    it "nullifies admin_id when admin is deleted" do
      admin.destroy
      expect(activity.reload.admin_id).to be_nil
    end
  end
end
