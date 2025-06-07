require 'rails_helper'

RSpec.describe User, type: :model do
  describe "password validation" do
    it "requires minimum 12 characters" do
      user = User.new(
        email: "test@example.com",
        password: "Short1!",
        username: "testuser"
      )
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 12 characters)")
    end
  end
end
