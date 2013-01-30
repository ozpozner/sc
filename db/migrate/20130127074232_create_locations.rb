class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :title , :default =>""
      t.string :address , :default =>""
      t.float :latitude
      t.float :longitude
      t.datetime :lastvisit , :default => '1 jan 2013 00:00'
      t.float :radius , :default => '2'
      t.integer :sitetype , :default => '1'
      t.string :bearing, :default => 'N'
      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
