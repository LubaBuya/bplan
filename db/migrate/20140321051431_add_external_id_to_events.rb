class AddExternalIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :externalID, :string, :limit => 255
  end
end
