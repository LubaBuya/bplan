# == Schema Information
#
# Table name: favorite_events
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  gcal       :boolean
#  sms        :boolean
#  email      :boolean
#

class FavoriteEvent < ActiveRecord::Base
  before_save :default_values

  validates :event_id, presence: true
  validates :user_id, presence: true

  belongs_to :event
  belongs_to :user

  def default_values
    self.gcal ||= false
    self.sms ||= false
    self.email ||= false

    return true
  end

end
