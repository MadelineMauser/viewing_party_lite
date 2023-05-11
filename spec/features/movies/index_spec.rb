require 'rails_helper'
require 'faker'

RSpec.describe 'Movies Index Page' do
  before(:each) do
    @user = User.create!(name: Faker::Name.unique.name, email: Faker::Internet.unique.free_email, password: 'test', password_confirmation: 'test')
    log_in_user(@user.id)
  end

  describe 'index' do
    it 'has movie names that are links to movie show page', :vcr do
      visit "/movies"
      expect(page).to have_link('Discover Top Rated Movies')

      click_link('Discover Top Rated Movies')
      expect(current_path).to eq("/movies")
      expect(page).to have_link('The Godfather')

      click_link 'The Godfather'
      expect(current_path).to eq(movie_path(238))
    end
  end
end
