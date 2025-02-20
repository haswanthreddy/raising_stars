require "rails_helper"

RSpec.describe Program, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:admin) }
    it { should have_many(:program_activities) }
    it { should have_many(:user_activities) }
  end

  describe "validations" do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }

    context "when checking for overlapping dates" do
      let(:user) { create(:user) }
      let!(:existing_program) { create(:program, user_id: user.id, start_date: Date.today, end_date: Date.today + 3.months) }

      it "is invalid if a new program overlaps with an existing one" do
        puts "Existing program count: #{Program.count}"
        puts "Existing program: #{Program.last.inspect}"
        overlapping_program = build(:program, user_id: user.id, start_date: Date.today + 5.days, end_date: Date.today + 4.months)

        expect(overlapping_program).not_to be_valid
        expect(overlapping_program.errors[:base]).to include("Program dates overlap with an existing record")
      end

      it "is valid if a new program does not overlap" do
        non_overlapping_program = build(:program, user: user, start_date: Date.today + 5.months, end_date: Date.today + 8.months)

        expect(non_overlapping_program).to be_valid
      end
    end

    context "when end_date is earlier than start_date" do
      it "should not create record and return error" do
        program = build(:program, start_date: Date.today, end_date: Date.today - 10.days)

        expect(program).not_to be_valid
        expect(program.errors.full_messages.to_sentence).to include("End date must be after start date")
      end
    end
  end

  describe "#deleted?" do
    let(:program) { create(:program) }

    context "when program is not deleted or deleted_at is not present" do
      it "shoudl return true" do
        expect(program.deleted?).to be false
      end
    end

    context "when program is deleted or deleted_at is not null" do
      it "should return false" do
        program.update(deleted_at: DateTime.now)
        
        expect(program.deleted?).to be true
      end
    end
  end

  describe "#current_day" do
    it "returns the number of days from the start date" do
      program = create(:program, start_date: Date.today.beginning_of_day - 10.days, end_date: Date.today + 3.months)
      
      expect(program.current_day).to eq(11)
    end
  end

  describe '#current_week_start_day' do
    let(:program) { create(:program, start_date: Date.today - 10.days) }

    it { expect(program.current_week_start_day).to eq(program.current_day - ((program.current_day - 1) % 7)) }

    context 'when current_day is a multiple of 7' do
      let(:program) { create(:program, start_date: Date.today - 6.days) }

      it { expect(program.current_week_start_day).to eq(1) }
    end

    context 'when current_day is 1' do
      let(:program) { create(:program, start_date: Date.today) }
      it { expect(program.current_week_start_day).to eq(1) }
    end
  end

  describe '#current_week_end_day' do
    let(:program) { create(:program, start_date: Date.today - 10.days) }

    it { expect(program.current_week_end_day).to eq(program.current_week_start_day + 6) }

    context 'when current_day is a multiple of 7' do
      let(:program) { create(:program, start_date: Date.today - 6.days) }
      it { expect(program.current_week_end_day).to eq(7) }
    end

    context 'when current_day is 1' do
      let(:program) { create(:program, start_date: Date.today) }
      it { expect(program.current_week_end_day).to eq(7) }
    end
  end
end