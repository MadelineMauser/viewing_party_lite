module UserLogInHelper
  def log_in_user(user_id, password)
    user = User.find(user_id)
    visit "/login"
    fill_in "Email", with: user.email
    fill_in "Password", with: password
    click_button "Log In"
  end
end