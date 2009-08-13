class AddStatusToErrorTypes < ActiveRecord::Migration
  def self.up
    add_column :error_types, :status, :integer, :default => 1
  end

  def self.down
    remove_column :error_types, :status
  end
end
