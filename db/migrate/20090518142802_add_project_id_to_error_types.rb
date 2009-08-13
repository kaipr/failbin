class AddProjectIdToErrorTypes < ActiveRecord::Migration
  def self.up
    add_column :error_types, :project_id, :integer
  end

  def self.down
    remove_column :error_types, :project_id
  end
end
