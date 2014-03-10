class ChangeCalendarToGcal < ActiveRecord::Migration
  def change
    rename_column :favorite_events, :calendar, :gcal
  end
end
