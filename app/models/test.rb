class Test < ActiveRecord::Base
  attr_accessible :title, :start_time, :end_time, :locations_id, :actions_id, :last_run, :next_run, :trafic_gen_id, :location_based, :time_based, :auto_start
end
