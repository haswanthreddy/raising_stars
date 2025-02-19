FactoryBot.define do
  factory :program_activity do
    association :program
    association :activity
  end
end
