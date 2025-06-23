FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name.gsub(/[^a-zA-Z0-9\s_]/, '') }
    email { Faker::Internet.unique.email }
    password { "Password123" }
  end
end
