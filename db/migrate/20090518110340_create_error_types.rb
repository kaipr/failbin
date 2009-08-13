class CreateErrorTypes < ActiveRecord::Migration
  def self.up
    create_table :error_types do |t|
      t.string :name
      t.string :controller
      t.string :action
      t.string :file
      t.integer :line
      t.text :backtrace
      t.string :backtrace_hash
      t.integer :error_count
      t.timestamps
    end
  end
  
  def self.down
    drop_table :error_types
  end
end
