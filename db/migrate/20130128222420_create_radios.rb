class CreateRadios < ActiveRecord::Migration
  def self.up
    create_table :radios do |t|
      t.string :title
      t.integer :location_id
      t.string :mac
      t.string :sn
      t.string :ip
      t.integer :devtype
      t.string :hwver
      t.string :swver
      t.string :contact
      t.datetime :last_update
      t.boolean :installed
      t.integer :airlink_id
      t.integer :lanlink_id
      t.integer :network_id
      t.string :sb_mask
      t.string :dgw
      t.timestamps
    end
  end

  def self.down
    drop_table :radios
  end
end
