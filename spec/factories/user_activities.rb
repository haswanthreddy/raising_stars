FactoryBot.define do
  factory :user_activity do
    association :activity
    association :program
  end
end
