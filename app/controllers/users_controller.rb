class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @parties_invited_to = @user.parties_invited_to
    @parties_hosting = @user.parties_hosting
  end

  def new; end

  def create
    @new_user = User.new(user_params)
    if @new_user.save
      redirect_to user_path(@new_user)
    else
      flash[:alert] = "Error: #{@new_user.errors.full_messages}"
      redirect_to '/register'
    end
  end

  def login_form
  end

  def login

  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
