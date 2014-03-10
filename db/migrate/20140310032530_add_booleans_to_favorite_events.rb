class AddBooleansToFavoriteEvents < ActiveRecord::Migration
  def change
    add_column :favorite_events, :calendar, :boolean
    add_column :favorite_events, :sms, :boolean
    add_column :favorite_events, :email, :boolean
  end
end
