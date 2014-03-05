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

  def logout
    cookies.delete :current_user
    redirect_to :root
  end
  
  def create
    params = user_params
    # params[:password_confirmation] = params[:password]

    @user = User.new(params)
    @user.save
    
    if @user.errors.empty?
      save_user_to_cookie(@user)
      render json: {
        errors: @user.nice_messages,
        success: true
      }
    else
      render json: {
        errors: @user.nice_messages,
        success: false
      }
    end
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
    @user = current_user
    if @user.blank?
      redirect_to :root
      return
    end

    @user_groups = Set.new(@user.groups.map(&:id))
    p @user_groups
  end

  def update_subscriptions
    ids = Set.new(params[:group_ids].map(&:to_i))

    @user = current_user
    groups = Set.new(@user.groups.map(&:id))

    to_remove = groups.difference(ids)
    to_add = ids.difference(groups)
    
    for id in to_remove
      s = Subscription.find_by_group_id_and_user_id(id, @user.id)
      s.delete
    end

    for id in to_add
      s = Subscription.create({user_id: @user.id, group_id: id})
    end

    render json: {
      success: true,
      errors: []
    }
  end

  def user_groups
    user = current_user
    if user.blank?
      render json: {
        groups: []
      }
    else
      render json: {
        groups: user.groups.map(&:id)
      }
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  
end
