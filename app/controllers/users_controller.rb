class UsersController < ApplicationController

  def login
    @user = User.new
  end
  
end
