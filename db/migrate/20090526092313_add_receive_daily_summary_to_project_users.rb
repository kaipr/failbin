class AddReceiveDailySummaryToProjectUsers < ActiveRecord::Migration
  def self.up
    add_column :project_users, :receive_daily_summary, :boolean
  end

  def self.down
    remove_column :project_users, :receive_daily_summary
  end
end
