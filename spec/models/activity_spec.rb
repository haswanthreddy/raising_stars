require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe "Associations" do
    it { should belong_to(:admin).optional }
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

  describe "enums" do
    it "defines correct values for frequency enum" do
      expect(Activity.frequencies).to eq({
        "daily" => 0,
        "weekly" => 1,
        "monthly" => 2
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
