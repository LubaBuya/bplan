# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
end
