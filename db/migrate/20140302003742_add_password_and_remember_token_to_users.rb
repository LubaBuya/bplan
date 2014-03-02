class AddPasswordAndRememberTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
    add_column :users, :remember_token, :string
    remove_column :users, :password
  end
end
