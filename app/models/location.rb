class Location < ActiveRecord::Base
  attr_accessible :title, :address, :latitude, :longitude, :lastvisit, :radius, :sitetype, :bearing
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
  after_validation :reverse_geocode,  :if => :latitude_changed?|| :longitude_changed?
 
 reverse_geocoded_by :latitude, :longitude do |obj,results|
   if geo = results.first
   	  #puts geo
      obj.address  = geo.address
    end
  end


end
