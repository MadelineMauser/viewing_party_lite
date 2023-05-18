require 'rails_helper'

RSpec.describe 'New Viewing Party' do
  before(:each) do
    @user1 = User.create!(name: Faker::Name.unique.name, email: Faker::Internet.unique.email, password: 'password321', password_confirmation: 'password321')
    @user2 = User.create!(name: Faker::Name.unique.name, email: Faker::Internet.unique.email, password: 'password321', password_confirmation: 'password321')
    @user3 = User.create!(name: Faker::Name.unique.name, email: Faker::Internet.unique.email, password: 'password321', password_confirmation: 'password321')
    @user4 = User.create!(name: Faker::Name.unique.name, email: Faker::Internet.unique.email, password: 'password321', password_confirmation: 'password321')

    log_in_user(@user1.id, @user1.password)

    visit '/movies/862/parties/new'
  end
  describe 'new party form' do
    it 'has fields for duration, date, time, checkboxes for each existing user, and a button to create', :vcr do
      expect(page).to have_field('Duration')
      expect(page).to have_field('Date')
      expect(page).to have_field('Start Time')
      expect(page).to have_field("users_#{@user2.id}")
      expect(page).to have_field("users_#{@user3.id}")
      expect(page).to have_field("users_#{@user4.id}")
      expect(page).to have_button('Create')
    end

    describe 'happy path' do
      it 'creates a new party and redirects to the user dashboard when the form is successfully submitted', :vcr do
        fill_in 'Duration', with: '90'
        fill_in 'Date', with: (Date.today + 5.days)
        fill_in 'Start Time', with: "14:00"
        check "users_#{@user2.id}"
        check "users_#{@user3.id}"
        click_button 'Create'

        expect(page).to have_current_path('/dashboard')
        within '#hosting' do
          expect(page).to have_content('Toy Story')
          expect(page).to have_content(@user2.name)
          expect(page).to have_content(@user3.name)
          expect(page).not_to have_content(@user4.name)
        end
      end
      it 'lists the new event in the dashboard of invited users', :vcr do
        fill_in 'Duration', with: '90'
        fill_in 'Date', with: (Date.today + 5.days)
        fill_in 'Start Time', with: "14:00"
        check "users_#{@user2.id}"
        check "users_#{@user3.id}"
        click_button 'Create'

        log_in_user(@user2.id, @user2.password)
        within '#invited_to' do
          expect(page).to have_content('Toy Story')
        end
        log_in_user(@user3.id, @user3.password)
        within '#invited_to' do
          expect(page).to have_content('Toy Story')
        end
        log_in_user(@user4.id, @user4.password)
        within '#invited_to' do
          expect(page).not_to have_content('Toy Story')
        end
      end
    end

    describe 'sad paths' do
      it 'does not create a new party if the party duration is shorter than the movie duration', :vcr do
        fill_in 'Duration', with: '30'
        fill_in 'Date', with: (Date.today + 5.days)
        fill_in 'Start Time', with: "14:00"
        check "users_#{@user2.id}"
        check "users_#{@user3.id}"
        click_button 'Create'

        expect(page).to have_current_path(new_movie_party_path(862))

        visit '/dashboard'
        within '#hosting' do
          expect(page).not_to have_content('Toy Story')
        end
      end
    end
  end
end
