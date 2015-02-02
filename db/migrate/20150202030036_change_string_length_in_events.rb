class ChangeStringLengthInEvents < ActiveRecord::Migration
  def change
    change_column :events, :title, :string, :limit => 2048
  end
end
