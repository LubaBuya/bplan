class UsersController < ApplicationController

  include UsersHelper
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def login
    @user = User.new
  end

  def create
    params = user_params
    # params[:password_confirmation] = params[:password]
    @user = User.new(params)
    @user.save
    
    # @user created in create_beta_user
    if @user.errors.empty?
      @success = true
      redirect_to root_path
    else
      @success = false
      render json: {
        errors: @user.nice_messages,
        success: @success
      }
    end

    save_user_to_cookie(@user) if @success
  end

  def login_post
    user = User.find_by_email(params[:user][:email].downcase)
    if user && user.authenticate(params[:user][:password])
      save_user_to_cookie(user)
      render json: {
        success: true,
        errors: []
      }
    else
      render json: {
        success: false,
        errors: ['Email or password invalid']
      }
    end
  end

  def subscriptions
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  
end
