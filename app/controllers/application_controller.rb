class ApplicationController < ActionController::Base
  helper_method :app_set
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper 
   
   def app_set(key)
       if set=Setting.find_by_key(key) then
          case Setting.find_by_key(key).mytype
          when 'String'
              return set.value
          when 'Integer'
            return set.value.to_i     
          when 'Float'
            return set.value.to_f     
          when 'TrueClass'
            return true
          when 'FalseClass' 
            return false
          else
            return set.value
          end
       else
          return APP_CONFIG[Rails.env][key]   
       end    
   end
     
   
   def app_set_class(key)
      set=Setting.find_by_key(key)
      if set != nil then 
      	return set.mytype
      else
      	return nil
      end	
   end	

	def authenticate
  		if app_set(perform_authentication) then
    		authenticate_or_request_with_http_basic do |username, password|
      			username == app_set('username') && password == app_set('password')
    		end #do
  		end #if
	end #def


end
