FactoryBot.define do
  factory :post do
    title { "A Test Post Title" }
    content { "This is the content of the test post." }
    association :user # Asocia el post a un usuario por defecto
  end
end