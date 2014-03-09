class AddReminderOffsetToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remind_email, :integer
    add_column :users, :remind_sms, :integer
  end
end
