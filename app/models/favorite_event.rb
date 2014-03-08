class FavoriteEvent < ActiveRecord::Base
	belongs_to :event
	belongs_to :user
end
