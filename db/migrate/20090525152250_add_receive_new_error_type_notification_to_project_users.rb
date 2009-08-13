class AddReceiveNewErrorTypeNotificationToProjectUsers < ActiveRecord::Migration
  def self.up
    add_column :project_users, :receive_new_error_type_notification, :boolean
  end

  def self.down
    remove_column :project_users, :receive_new_error_type_notification
  end
end
