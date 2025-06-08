# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    username { Faker::Internet.unique.username }
    password { "password123456" }
    password_confirmation { "password123456" }
  end
end