class Location < ActiveRecord::Base
  #include ApplicationController.helper.app_set
  attr_accessible :title, :address, :latitude, :longitude, :lastvisit, :radius, :sitetype, :bearing
  after_validation :geocode, :if => :address_changed?
  after_validation :reverse_geocode,  :if => :latitude_changed?|| :longitude_changed?
 
 reverse_geocoded_by :latitude, :longitude do |obj,results|
   if (geo  = results.first) && app_set('autogeocodeaddress') then
   	  #puts geo
      obj.address  = geo.address||obj.address unless (:address_changed?|| :address !="")
    end
  end

  geocoded_by :address do |obj,results|
  	if (geo  = results.first) && app_set('autogeocodeaddress') then
      obj.latitude = geo.latitude||1.0 unless :latitude_changed?
      obj.longitude = geo.longitude||1.0 unless :longitude_changed?
    else 
      obj.latitude = obj.latitude||0.0
      obj.longitude = obj.longitude||0.0
  	end
  end
end


   def app_set(key)
       if set=Setting.find_by_key(key).value then
          case Setting.find_by_key(key).mytype
          when 'String'
              return set
          when 'Integer'
            return set.to_i     
          when 'Float'
            return set.to_f     
          when 'TrueClass'
            return true
          when 'FalseClass' 
            return false
          else
            return set
          end
       else
          return APP_CONFIG[Rails.env][key]   
       end    
   end
     