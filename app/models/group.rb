# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  color      :string(255)
#

class Group < ActiveRecord::Base

  has_many :subscriptions
  has_many :users, through: :subscriptions

  # DEFAULT_GROUPS =
  #   []
  
end
