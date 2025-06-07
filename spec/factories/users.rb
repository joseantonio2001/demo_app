FactoryBot.define do
    factory :user do
        email { "user#{rand(1000)}@example.com" }
        username { "user#{rand(1000)}" }
        password { "SecurePassword123!" }
    end
end