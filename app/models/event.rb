# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  event_type  :string(255)
#  start_at    :datetime
#  end_at      :datetime
#  location    :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  group_id    :integer
#  url         :string(2048)
#

class Event < ActiveRecord::Base

  belongs_to :group

  has_many :favorite_events #just estabilishing the relationship between a user and this event
  has_many :favorited_by, through: :favorite_events, source: :user 
  # source means 

end
