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
  
  before_save { create_remember_token if (self.remember_token.blank? && self.password_digest && defined?(self.password_digest)) }
  before_save { |user| user.email = email.downcase }
   
  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
