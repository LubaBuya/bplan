# == Schema Information
#
# Table name: favorite_events
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  calendar   :boolean
#  sms        :boolean
#  email      :boolean
#

class FavoriteEvent < ActiveRecord::Base
	before_save :default_values

	validates :calendar, presence: true
	validates :sms, presence: true
	validates :email, presence: true

	belongs_to :event
	belongs_to :user

	def default_values
		self.calendar ||= false
		self.sms ||= false
		self.email ||= false
	end

end
