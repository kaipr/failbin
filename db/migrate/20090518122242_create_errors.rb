class CreateErrors < ActiveRecord::Migration
  def self.up
    create_table :errors do |t|
      t.integer :error_type_id
      t.string :rails_environment
      t.string :request_type
      t.string :url
      t.text :params
      t.text :session
      t.text :environment
      t.datetime :thrown_at
      t.timestamps
    end
  end
  
  def self.down
    drop_table :errors
  end
end
