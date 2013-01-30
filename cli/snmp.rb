require 'snmp'
include SNMP


  #### loger
  require 'logger'

#  log = Logger.new(STDOUT)
#  m = SNMP::TrapListener.new do |manager|
#      manager.on_trap_default do |trap|
#          log.info trap.inspect
#      end
#  end
#  m.join

  ##### logger end

# targetIP ='10.0.5.120'
 targetIP ='10.0.0.121'
 def browse (host)
 SNMP::Manager.open(:host => host) do |manager|
      response = manager.get(["sysDescr.0", "sysName.0"])
      response.each_varbind do |vb|
          puts "#{vb.name.to_s}  #{vb.value.to_s}  #{vb.value.asn1_type}"
      end
  end
 end

  def getattrib (host,oid,community,numofelemetstoreturn)
	out = ""
  	manager = SNMP::Manager.new(:host => host, :port => 161, :community => community , :version => :SNMPv1)
   	response = manager.get([oid])
   	response.each_varbind do |vb|
   	    index=0 
   		vb.inspect.split.each do |val|
   	     	# puts ("#{index}:"+ val.to_s.gsub(/value=/,''))
   	     	
   	     	if index ==1 then
   	     		out =  val.to_s.gsub(/value=/,'') 
   	     	else 
   	     		if (index<=numofelemetstoreturn && index >1) then
   	     		    out +=" "+val.to_s 
   	     		end
   	     	end		
   	     	index+=1
   	     end  	
   	end
    manager.close
    return out
  end

  def setattrib_string (host,oid,community,newvalue)
	 manager = SNMP::Manager.new(:host => host, :port => 161, :community => community , :version => :SNMPv1)
	 varbind = VarBind.new(oid, OctetString.new(newvalue))
     manager.set(varbind)
     manager.close
   end

   def setattrib_integer (host,oid,community,newvalue)
	 manager = SNMP::Manager.new(:host => host, :port => 161, :community => community , :version => :SNMPv1)
	 varbind = VarBind.new(oid, SNMP::Integer.new(newvalue))
     manager.set(varbind)
     manager.close
   end
 
   def setattrib_IP (host,oid,community,newvalue)
	 manager = SNMP::Manager.new(:host => host, :port => 161, :community => community , :version => :SNMPv1)
	 varbind = VarBind.new(oid, SNMP::IpAddress.new(newvalue))
     manager.set(varbind)
     manager.close
   end
 
 
  def hwVersion (host)
  	getattrib(host,"1.3.6.1.4.1.29612.1000.1.1.2.0", 'public',1)
  end  

puts ("MAC is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.3.2.1.5.1", 'public',4))
puts ("Description is " + getattrib(targetIP,"1.3.6.1.2.1.1.1.0", 'netman',5))
puts ("HW Ver is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.2.0", 'public',4))
puts ("SW is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.3.0", 'public',4))
puts ("linkname n/a is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.4.0", 'public',4))
puts ("reset n/a is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.5.0", 'public',4))
puts ("IP is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.6.0", 'public',4))
puts ("NETMASK is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.7.0", 'public',4))
puts ("DGW is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.8.0", 'public',4))
puts ("setting DGW to 10.0.0.254")
setattrib_IP(targetIP,"1.3.6.1.4.1.29612.1000.1.1.8.0", 'netman','10.0.0.254')
puts ("DGW is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.8.0", 'public',4))
setattrib_IP(targetIP,"1.3.6.1.4.1.29612.1000.1.1.8.0", 'netman','10.0.0.1')
puts ("my RSS is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.9.1.0", 'public',4))
puts ("5.9.2 is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.9.2.0", 'public',4))
puts ("5.9.3 is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.9.3.0", 'public',4))
puts ("5.9.4 is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.9.4.0", 'public',4))
puts ("5.9.6 is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.9.5.0", 'public',4))

puts ("1.1.16 is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.16.0", 'public',4))
puts ("1.1.17 is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.17.0", 'public',4))
puts ("1.1.18 is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.18.0", 'public',4))
puts ("my S/N is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.29.0", 'public',4))
puts ("1.1.20 is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.20.0", 'public',4))

puts("Radio")
puts ("recieved signal str is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.9.1.0", 'public',4))
puts ("wbbOduAirTotalFrames is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.9.2.0", 'public',4))
puts ("5.9.3 is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.9.3.0", 'public',4))
puts ("5.9.4 is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.9.4.0", 'public',4))
puts ("5.9.5 is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.9.5.0", 'public',4))

puts ("Center Band is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.1.0", 'public',4))
puts ("wbbOduAirDesiredRate is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.2.0", 'public',4))
puts ("SSID is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.3.0", 'public',4))
puts ("TX power is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.4.0", 'public',4))
puts (" setting TX power to -7")
setattrib_integer(targetIP,"1.3.6.1.4.1.29612.1000.1.5.4.0", 'netman','-7')
puts ("new TX power is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.4.0", 'public',1))
#wbbOduAirTxPower 1.3.6.1.4.1.29612.1000.1.5.4 Integer RW Required Transmit power in dBm . This is a
#nominal value while the actual transmit power
#includes additional attenuation. The min and max
#values are product specific. A change is effective
#immediately.
#wbbOduAirSesState 1.3.6.1.4.1.29612.1000.1.5.5 Integer RO Current Link State. The value is active (3) during
#normal operation.
#wbbOduAirMstrSlv 1.3.6.1.4.1.29612.1000.1.5.6 Integer RO This parameter indicates if the device was
#automatically selected into the radio link master or
#slave. The value is undefined if there is no link

puts ("wbbOduAirSesState is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.5.0", 'public',1))
puts ("wbbOduAirMstrSlv is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.6.0", 'public',1))

puts ("5.23 is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.23", 'public',1))
puts ("5.25 is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.25", 'public',1))
puts ("channel BW is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.24.0", 'public',1))
puts ("subbands is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.53.3.0", 'public',1))
puts ("gauge  is" + getattrib(targetIP,"1.3.6.1.2.1.2.2.1.5.0", 'public',5))

puts ("wbbOduAdmLinkName is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.4.0", 'public',5))
puts ("myIP is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.6.0", 'public',5))
puts ("myMAsk is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.7.0", 'public',5))
puts ("buzzer is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.13.0", 'public',5))
puts ("Remote name is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.1.19.0", 'public',5))
puts ("wbbOduAirDualAntTxMode is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.1.5.58.0", 'public',5))

#wbbOduAirDualAntTxMode 1.3.6.1.4.1.29612.1000.1.5.58 Integer RW Description: Transmission type when using Dual
#radios (MIMO or AdvancedDiversity using one
#stream of data).
#wbbIduSrvEthThroughput 1.3.6.1.4.1.29612.1000.2.2.14 Gauge RO Current available Ethernet service throughput in
#bps
puts ("ethernet gauge is " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.2.2.14", 'public',5))
#.ifSpeed .1.3.6.1.2.1.2.2.1.5 Gauge RO An estimate of the interface's current bandwidth in
#bits per second.For interfaces which do not vary in
#bandwidth or for those where no accurate
#estimation can be made, this object should ontain
#the nominal bandwidth.
puts ("ethernet gauge is " + getattrib(targetIP,"1.3.6.1.2.1.2.2.1.5.0", 'public',5))

#wbbOduAirTxOperationMode 1.3.6.1.4.1.29612.1000.1.5.59 Integer RW This parameter controls the Operation mode of
#frames sent over the air. The Operation mode is
#either normal (1) for regular transmission where
#frame size is determined by the traffic or
#throughput test (2) when the user requests an
#actual over the air throughput estimation using full
#frames. The latter lasts no more than a
#predetermined interval (default 30 sec).

#puts ("?1 -" + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.4.1.1.0", 'public',5))
#puts ("?2 -" + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.4.1.2.0", 'public',5))
#puts ("?3 - " + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.4.1.3.0", 'public',5))
#puts ("?5 -" + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.4.1.5.0", 'public',5))
#puts ("?6-" + getattrib(targetIP,"1.3.6.1.4.1.29612.1000.4.1.6.0", 'public',5))
 

def hextoip (inputstring)
	out=""
    out+=inputstring[0..1].to_i(16).to_s+"."
    out+=inputstring[2..3].to_i(16).to_s+"."
    out+=inputstring[4..5].to_i(16).to_s+"."
    out+=inputstring[6..7].to_i(16).to_s
    return out
end	

def displayMyHBS (host,community)
	out = Hash.new
	input = Array.new
	snmp_output = getattrib(host, "1.3.6.1.4.1.29612.1000.4.1.7.0", community,10)
    input = snmp_output.split(',')
    out = {:name=>input[0], :ip=>hextoip(input[1]), :mask=>hextoip(input[2])}
end

def displayMyHSU (host, community)
	out = Hash.new
	input = Array.new
    input = getattrib('10.0.1.1',"1.3.6.1.4.1.29612.1000.3.1.7.2.1.23.1", 'public',50).split(',')
    out = {:ip=>hextoip(input[1]) , :name=>input[2], :location=>input[3], :SN=>input[4]}
end	

if hwVersion(targetIP)=='3' then #HSU
	partner=displayMyHBS(targetIP,'public')
	puts("I am HSU his name is "+partner[:name]+ " and it\'s IP is:"+ partner[:ip]) 
end	

if  hwVersion(targetIP)=='6' then #HBS
	partner=displayMyHSU(targetIP,'public')
	puts("I am HBS my HSU is:"+ partner[:name]+" it\'s S/N:"+ partner[:SN]+" located at:"+partner[:location]+" and it\'s IP is:"+ partner[:ip]) 
end
#puts("HSU IP: "+ hsu_ip)
#partner = displaypartner( hsu_ip ,'public')
#puts ("HBS IP: "+partner[:ip])

