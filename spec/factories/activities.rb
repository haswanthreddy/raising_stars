FactoryBot.define do
  factory :activity do
    association :admin
    name { "sample activity" }
    description { "sample description" }
    category { Activity.categories.keys.sample }
    frequency { Activity.frequencies.keys.sample }
    repetition { rand(1..3) }
  end
end
