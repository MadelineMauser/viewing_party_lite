require 'rails_helper'

RSpec.describe 'New User Registration' do
  before(:each) do
    visit '/register'
    @email = Faker::Internet.email
    @email2 = Faker::Internet.email
  end
  describe 'registration form' do
    it 'has fields for a name and email and a button to register' do
      expect(page).to have_field('Name')
      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
      expect(page).to have_field('Confirm Password')
      expect(page).to have_button('Register')
    end

    describe 'happy path' do
      it 'creates a new user and redirects to the dashboard for that user when the form is successfully submitted' do
        fill_in 'Name', with: 'John Doe'
        fill_in 'Email', with: @email
        fill_in 'Password', with: 'password'
        fill_in 'Confirm Password', with: 'password'
        click_button 'Register'
        
        new_user = User.find_by(name: 'John Doe')
        expect(page).to have_current_path('/dashboard')
        expect(@current_user).to eq(new_user)
        expect(new_user.email).to eq(@email)
      end
    end

    describe 'sad paths' do
      it 'does not create a new user if the submitted email is identical to an existing user email' do
        User.create!(name: 'John Doe', email: @email, password: 'test', password_confirmation: 'test')
        fill_in 'Name', with: 'Imposter John'
        fill_in 'Email', with: @email
        fill_in 'Password', with: 'password'
        fill_in 'Confirm Password', with: 'password'
        click_button 'Register'

        expect(page).to have_current_path('/register')
        expect(User.exists?(name: 'Imposter John', email: @email)).to eq(false)
      end
      it 'does not create a new user if the password is not identical to the confirm password' do
        User.create!(name: 'John Doe', email: @email, password: 'test', password_confirmation: 'test')
        fill_in 'Name', with: 'Imposter John'
        fill_in 'Email', with: @email2
        fill_in 'Password', with: 'password'
        fill_in 'Confirm Password', with: 'password123'
        click_button 'Register'

        expect(page).to have_current_path('/register')
        expect(User.exists?(name: 'Imposter John', email: @email2)).to eq(false)
        expect(page).to have_content("Error: ")
      end
      it 'does not create a new user if the password is missing' do
        User.create!(name: 'John Doe', email: @email, password: 'test', password_confirmation: 'test')
        fill_in 'Name', with: 'Imposter John'
        fill_in 'Email', with: @email2
        fill_in 'Confirm Password', with: 'password123'
        click_button 'Register'

        expect(page).to have_current_path('/register')
        expect(User.exists?(name: 'Imposter John', email: @email2)).to eq(false)
        expect(page).to have_content("Error: ")
      end
      it 'does not create a new user if the password confirmation is missing' do
        User.create!(name: 'John Doe', email: @email, password: 'test', password_confirmation: 'test')
        fill_in 'Name', with: 'Imposter John'
        fill_in 'Email', with: @email2
        fill_in 'Password', with: 'password'
        click_button 'Register'

        expect(page).to have_current_path('/register')
        expect(User.exists?(name: 'Imposter John', email: @email2)).to eq(false)
        expect(page).to have_content("Error: ")
      end
    end
  end
end

