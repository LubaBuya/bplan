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
#  department  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Event < ActiveRecord::Base
end
