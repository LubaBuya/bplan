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
  has_many :events

  # DEFAULT_GROUPS =   []

  def self.groups_hash
    names = Hash.new
    colors = Hash.new
    
    all.each do |g|
      names[g.id] = g.name
      colors[g.id] = g.color
    end
    return names, colors
  end
  
end
