FactoryBot.define do
  factory :student do
    association :campus
    name { "Arun Kumar" }
    email { "arun@example.com" }
    date_of_birth { Date.new(2005, 6, 15) }
  end
end