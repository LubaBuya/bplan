class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :event_type
      t.datetime :start_at
      t.datetime :end_at
      t.string :location
      t.text :description
      t.string :department

      t.timestamps
    end
  end
end
