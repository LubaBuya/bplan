class CreateFavoriteEvents < ActiveRecord::Migration
  def change
    create_table :favorite_events do |t|
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
  end
end
