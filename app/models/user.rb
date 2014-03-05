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
#  name            :string(255)
#

class User < ActiveRecord::Base
  has_secure_password

  has_many :subscriptions
  has_many :groups, through: :subscriptions
  
  before_save { create_remember_token if (self.remember_token.blank? && self.password_digest && defined?(self.password_digest)) }
  before_save { |user| user.email = email.downcase }
   
  DISPLAY_FIELDS = {fname: "First name", lname: "Last name", name: "Name",
    email: "Email", password: "Password", password_confirmation: "Password confirmation"}

  # E-mail regex
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: false }

  def nice_messages
    out = []
    for tag, messages in errors.messages do
      nice_name = DISPLAY_FIELDS.fetch(tag, tag.to_s.capitalize)
      messages.each do |msg|
        m = "#{nice_name} #{msg}"
        m = m.sub(/\scan't\s/, " shouldn't ")
        out << m
      end
    end
    return out
  end

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
