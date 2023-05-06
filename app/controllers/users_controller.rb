class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new; end

  def create
    @new_user = User.new(user_params)
    if @new_user.save
      session[:user_id] = @new_user.id
      redirect_to '/dashboard'
    else
      flash[:alert] = "Error: #{@new_user.errors.full_messages}"
      redirect_to '/register'
    end
  end

  def login_form
  end

  def login
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to '/dashboard'
    else
      flash[:alert] = "Login failed. Please check that your credentials are correct."
      redirect_to :back
    end
  end

  def dashboard
    @user = @current_user
    @parties_invited_to = @user.parties_invited_to
    @parties_hosting = @user.parties_hosting
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
