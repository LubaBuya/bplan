class AddNickNameToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :nickname, :string
  end
end
