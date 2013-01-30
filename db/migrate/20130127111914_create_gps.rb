class CreateGps < ActiveRecord::Migration
  def self.up
    create_table :gps do |t|
      t.string :latitude
      t.string :longitude
      t.datetime :datetime
      t.integer :testid
      t.timestamps
    end
  end

  def self.down
    drop_table :gps
  end
end
