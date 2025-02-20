require 'rails_helper'

RSpec.describe UserActivity, type: :model do
  describe "Associations" do
    it { should belong_to(:program) }
    it { should belong_to(:activity) }
  end
end
