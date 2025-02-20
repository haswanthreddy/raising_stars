require "rails_helper"

RSpec.describe ProgramActivity, type: :model do
  describe "Associations" do
    it { should belong_to(:program) }
    it { should belong_to(:activity) }
  end

  describe "Validations" do
    let(:program) { create(:program) }
    let(:activity) { create(:activity, repetition: 2, frequency: "weekly") }
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
        activity = create(:activity, frequency: "weekly", repetition: 3)
        program_activity = create(:program_activity, activity: activity, frequency: nil)
        
        expect(program_activity.frequency).to eq(activity.frequency)
      end
    end

    context "when frequency attribute is set" do
      it "returns it" do
        activity = create(:activity, frequency: "daily")
        program_activity = create(:program_activity, activity: activity, frequency: Activity.frequencies[:weekly])
        
        expect(program_activity.frequency.to_sym).to eq(:weekly)
      end
    end
  end
  
  describe "enums" do
    it "defines correct values for frequency enum" do
      expect(ProgramActivity.frequencies).to eq({
        "daily" => 0,
        "weekly" => 1,
      })
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
        program_activity = create(:program_activity, activity: activity, repetition: 3)
        
        expect(program_activity.repetition).to eq(3)
      end
    end
  end

  describe "custom repetition validation" do
    context "when frequency is weekly" do
      it "is invalid if repetition  more than 3" do
        program_activity = build(:program_activity, frequency: "weekly", repetition: 4)
       
        expect(program_activity).not_to be_valid
        expect(program_activity.errors[:repetition]).to include("must be 3 or less for weekly frequency")
      end

      it "is valid if repetition is 3 or less" do
        program_activity = build(:program_activity, frequency: "weekly", repetition: 3)

        expect(program_activity).to be_valid
      end
    end

    context "when frequency is daily" do
      it "is valid repetition 10 or less" do
        program_activity  = build(:program_activity, frequency: "daily", repetition: 10)

        expect(program_activity).to be_valid
      end

      it "is invalid if repetition is more than 10" do
        program_activity = build(:program_activity, frequency: "daily", repetition: 11)

        expect(program_activity).not_to be_valid
      end
    end
  end

  describe '#weekday_occurrences?' do
    let(:program_activity) { create(:program_activity) }

    context 'when repetition is 3 and frequency is weekly' do
      before { program_activity.repetition = 3 }

      it 'returns true for Tuesday, Thursday, and Saturday' do
        expect(program_activity.weekday_occurrences?(2)).to be true
        expect(program_activity.weekday_occurrences?(4)).to be true
        expect(program_activity.weekday_occurrences?(6)).to be true
      end

      it 'returns false for other weekdays' do
        expect(program_activity.weekday_occurrences?(1)).to be false # Monday
        expect(program_activity.weekday_occurrences?(3)).to be false # Wednesday
        expect(program_activity.weekday_occurrences?(5)).to be false # Friday
        expect(program_activity.weekday_occurrences?(7)).to be false # Sunday
      end
    end

    context 'when repetition is 2' do
      before { program_activity.repetition = 2 }

      it 'returns true for Wednesday and Friday' do
        expect(program_activity.weekday_occurrences?(3)).to be true
        expect(program_activity.weekday_occurrences?(5)).to be true
      end

      it 'returns false for other weekdays' do
        expect(program_activity.weekday_occurrences?(1)).to be false
        expect(program_activity.weekday_occurrences?(2)).to be false
        expect(program_activity.weekday_occurrences?(4)).to be false
        expect(program_activity.weekday_occurrences?(6)).to be false
        expect(program_activity.weekday_occurrences?(7)).to be false
      end
    end

    context 'when repetition is 1' do
      before { program_activity.repetition = 1 }

      it 'returns true for Thursday' do
        expect(program_activity.weekday_occurrences?(4)).to be true
      end

      it "returns false for all days other than Thursday" do
        expect(program_activity.weekday_occurrences?(1)).to be false
        expect(program_activity.weekday_occurrences?(2)).to be false
        expect(program_activity.weekday_occurrences?(5)).to be false
        expect(program_activity.weekday_occurrences?(6)).to be false
        expect(program_activity.weekday_occurrences?(7)).to be false
      end
    end
  end
end
