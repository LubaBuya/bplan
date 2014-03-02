# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#  remember_token  :string(255)
#

class User < ActiveRecord::Base
  has_secure_password

  has_many :subscriptions
  has_many :groups, through: :subscriptions
  
  
  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
