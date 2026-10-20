FactoryBot.define do
  factory :user do
    association :campus
    sequence(:email) { |n| "teacher#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    role { "teacher" }
  end
end