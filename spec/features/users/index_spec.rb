require 'rails_helper'
require 'faker'

RSpec.describe 'Users' do
  before(:each) do
    @user1 = User.create!(name: Faker::Name.unique.name, email: Faker::Internet.unique.email, password: 'password321', password_confirmation: 'password321')
    @user2 = User.create!(name: Faker::Name.unique.name, email: Faker::Internet.unique.email, password: 'password321', password_confirmation: 'password321')
    @user3 = User.create!(name: Faker::Name.unique.name, email: Faker::Internet.unique.email, password: 'password321', password_confirmation: 'password321')
    @user4 = User.create!(name: Faker::Name.unique.name, email: Faker::Internet.unique.email, password: 'password321', password_confirmation: 'password321')
  end

  describe 'index' do
    it 'displays all users', :vcr do
      visit "/users"
      expect(page).to have_content(@user1.name)
    end
  end
end
