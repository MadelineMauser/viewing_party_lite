require 'rails_helper'
require 'faker'

RSpec.describe 'Login' do
  before(:each) do
    @user1 = User.create!(name: Faker::Name.unique.name, email: Faker::Internet.unique.email, password: 'password321', password_confirmation: 'password321')
  end

  describe 'login form' do
    it 'has a link on the home page', :vcr do
      visit '/'
      click_link 'Log In'
      expect(page).to have_current_path('/login')
    end
    it 'has a form to submit login information', :vcr do
      visit "/users"
      expect(page).to have_content(@user1.name)
    end
  end
end