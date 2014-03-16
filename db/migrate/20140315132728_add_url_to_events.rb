class AddUrlToEvents < ActiveRecord::Migration
  def change
    add_column :events, :url, :string, :limit => 2048
  end
end
