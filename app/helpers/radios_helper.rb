module RadiosHelper
   def onelinedisplay(radio)
    return ("
     <tr>\n
      <td><%= #{radio.title} %></td> 
      <td><%= #{radio.location_id} %></td> 
      <td><%= #{radio.mac} %></td> 
      <td><%= #{radio.sn} %></td> 
      <td><%= #{radio.ip} %></td> 
      <td><%= #{radio.devtype} %></td> 
      <td><%= #{radio.hwver} %></td> 
      <td><%= #{radio.swver} %></td> 
      <td><%= #{radio.contact} %></td> 
      <td><%= #{radio.last_update} %></td> 
      <td><%= link_to \"Show\", radio , class: \"btn btn-small btn-secondary\" %> |
          <%= link_to \"Edit\", edit_radio_path(radio) , class: \"btn btn-small btn-secondary\" %> |
          <%= link_to \"Destroy\", radio, :confirm => \'Are you sure?\', :method => :delete , class: \"btn btn-small btn-secondary\"%></td>
     </tr> ")
     end	
end
