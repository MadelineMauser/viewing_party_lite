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
      visit "/login"
      
      expect(page).to have_field("Email")
      expect(page).to have_field("Password")
      expect(page).to have_button("Log In")
    end
    it 'logs the user in and redirects to the user dashboard' do
      visit "/login"
      fill_in "Email", with: @user1.email
      fill_in "Password", with: @user1.password
      click_button "Log In"
      expect(page).to have_current_path("/dashboard")
      expect(page).to have_content(@user1.name)
    end
  end
end