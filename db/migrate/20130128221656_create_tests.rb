class CreateTests < ActiveRecord::Migration
  def self.up
    create_table :tests do |t|
      t.string :title
      t.datetime :start_time
      t.datetime :end_time
      t.integer :locations_id
      t.integer :actions_id
      t.datetime :last_run
      t.datetime :next_run
      t.integer :trafic_gen_id
      t.boolean :location_based
      t.boolean :time_based
      t.boolean :auto_start
      t.timestamps
    end
  end

  def self.down
    drop_table :tests
  end
end
