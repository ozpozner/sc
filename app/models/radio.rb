class Radio < ActiveRecord::Base
  attr_accessible :title, :location_id, :mac, :sn, :ip, :devtype, :hwver, :swver, :contact, :last_update, :installed, :airlink_id, :lanlink_id, :network_id, :sb_mask, :dgw
end
