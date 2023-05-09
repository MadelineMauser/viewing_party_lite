module UserLogInHelper
  def log_in_user(user_id)
    visit "/login"
    fill_in "Email", with: @user1.email
    fill_in "Password", with: @user1.password
    click_button "Log In"
  end
end