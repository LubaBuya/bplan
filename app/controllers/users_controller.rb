class UsersController < ApplicationController

  include UsersHelper
  
  def login
    @user = User.new
  end

  def create_post
    params = user_params
    # params[:password_confirmation] = params[:password]
    @user = User.new(params)
    @user.save
    
    # @user created in create_beta_user
    if @user.errors.empty?
      @success = true
    else
      @success = false
    end
    save_user_to_cookie(@user) if @success
    
    render json: {
      errors: @user.nice_messages,
      success: @success
    }
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

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end

  
end
