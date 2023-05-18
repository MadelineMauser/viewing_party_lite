require 'rails_helper'
require 'faker'

RSpec.describe 'Movies Index Page' do
  before(:each) do
    @user = User.create!(name: Faker::Name.unique.name, email: Faker::Internet.unique.free_email, password: 'test', password_confirmation: 'test')
    log_in_user(@user.id, @user.password)
    visit "/movies"
  end

  describe 'index' do
    it 'has movie names that are links to movie show page', :vcr do
  
      expect(page).to have_link('The Godfather')

      click_link 'The Godfather'
      expect(current_path).to eq(movie_path(238))
    end

    describe 'search' do
      it 'has a search bar that links to movies results page', :vcr do
        fill_in "search",	with: "Up"
        click_button 'Find Movies'

        expect(page.status_code).to eq(200)
      end
  
      it 'will not search for movies without valid search term(s)', :vcr do
        fill_in "search",	with: ""
        click_button 'Find Movies'
  
        expect(current_path).to eq("/movies")
      end
    end
  end
end
