module UsersHelper

  def save_user_to_cookie(a_user)
    cookies[:current_user] = { value: a_user.remember_token,
      expires: 20.years.from_now }
  end

end
