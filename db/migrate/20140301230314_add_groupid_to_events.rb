class AddGroupidToEvents < ActiveRecord::Migration
  def change
    add_column :events, :group_id, :integer
    remove_column :events, :department
  end
end
