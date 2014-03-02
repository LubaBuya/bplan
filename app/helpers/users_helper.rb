module UsersHelper

  def save_user_to_cookie(a_user)
    cookies[:current_user] = { value: a_user.remember_token,
      expires: 20.years.from_now }
  end

  def current_user
    if !defined?(cookies[:current_user]) || cookies[:current_user].blank?
      return nil
    else
      return User.find_by_remember_token(cookies[:current_user])
    end
  end


end
