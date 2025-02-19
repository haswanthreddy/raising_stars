require 'rails_helper'

RSpec.describe ProgramActivity, type: :model do
  describe "Associations" do
    it { should belong_to(:program) }
    it { should belong_to(:activity) }
  end

  describe "Validations" do
    let(:program) { create(:program) }
    let(:activity) { create(:activity) }
    before { create(:program_activity, program: program, activity: activity) }

    it "validates uniqueness of activity within the scope of program" do
      duplicate = build(:program_activity, program: program, activity: activity)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:activity_id]).to include("already exists for this program")
    end
  end

  describe "#frequency" do
    context "when frequency attribute is null" do
      it "should return activity frequency value" do
        program_activity = create(:program_activity, frequency: nil)
        activity = program_activity.activity
        
        expect(program_activity.frequency).to eq(activity.frequency)
      end
    end

    context "when frequency attribute is set" do
      it "returns it" do
        activity = create(:activity, frequency: Activity.frequencies[:daily])
        program_activity = create(:program_activity, activity: activity, frequency: Activity.frequencies[:weekly])
        
        expect(program_activity.frequency.to_sym).to eq(:weekly)
      end
    end
  end

  describe "#repetition" do
    context "when repetition attribute is null" do
      it "should return activity repetition value" do
        program_activity = create(:program_activity, repetition: nil)
        activity = program_activity.activity
        
        expect(program_activity.repetition).to eq(activity.repetition)
      end
    end

    context "when repetition attribute is set" do
      it "returns it" do
        activity = create(:activity, repetition: 2)
        program_activity = create(:program_activity, activity: activity, repetition: 4)
        
        expect(program_activity.repetition).to eq(4)
      end
    end
  end
end
