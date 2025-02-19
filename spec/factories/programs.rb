FactoryBot.define do
  factory :program do
    association :user
    association :admin
    title { "first program" }
    start_date { Date.today - 1.day }
    end_date { Date.today + 1.month }
  end
end
