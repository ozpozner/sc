# mechenize
require 'rubygems'
require 'mechanize'

@host='10.0.0.121'
@pathhome = "c:\\Users\\ozp\\apps\\smallcloud\\"

def setup
	@agent = Mechanize.new
	# @agent.ca_file = 'c:\Users\ozp\apps\smallcloud\app\games\curl-ca-buncle.crt'
	# @agent.agent.http.ca_file = 'lib/curl-ca-bundle.crt'
	@cert_store = OpenSSL::X509::Store.new
	@cert_store.add_file (@pathhome+'lib\cacert.pem')
	@agent.agent.http.ca_file=@pathhome+'\games\curl-ca-buncle.crt'
	@agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
	@agent.add_auth("http://#{@host}/",'admin','wireless')
	@formids=0
    @forms=Array.new
    @params=Hash.new
	#puts @agent
end

def subpage(mypage,link)
	puts "--------parsing link:"+mypage.to_s+" -->"+link.text
  		if  mypage.link_with(:text => link.text)!=nil then
  			  mypage.links_with(:text => link.text).each do |mypagelink|
  				page1 = mypagelink.click 
  				#pp page1
  				page1.forms.each do |form|
  					#puts form
  		   			@forms[@formids] = form
  		   			form.fields.each do |field|
  		   			pp field
  		   			@params.store( field.name , field.value )
  		   			end	
  		   			@formids +=1
  		   		end	
  		   	  end	
  	    end
end	

#main
	setup 
	#page = @agent.get("https://#{@host}/")
	#pp page
	page = @agent.get("http://#{@host}/cgi-bin/webif/info.sh?cat=Status")
	#pp page
  
	page.links.each do |link|
		subpage(@agent.page, link)
  	end
  	page = @agent.get("http://#{@host}/cgi-bin/webif/wireless-va1.sh")
  	page.links.each do |link|
		subpage(@agent.page, link)
  	end
   # pp @forms
     pp @params

  ##<Mechanize::Form
 #{name nil}
 #{method "POST"}
 #{action "/cgi-bin/webif/system-settings.sh"}
 #{fields
 # [hidden:0x16c3f8c type: hidden name: submit value: 1]
 # [text:0x19117c8 type: text name: hostname value: AP]
 # [text:0x19116f0 type: text name: contact value: name]
 # [text:0x1911618 type: text name: location value: location]
 # [text:0x1911534 type: text name: show_TZ value: This field requires the Java Script support.]
 # [text:0x1911420 type: text name: ntp_server_cfg023008 value: ]
 # [text:0x1911330 type: text name: ntp_port_cfg023008 value: 123]
 # [selectlist:0x1910b5c type:  name: system_timezone value: []]}
 #{buttons
 # [submit:0x16c3e00 type: submit name: action value: Save]
 # [submit:0x16c3ba8 type: submit name:  value: Yes]
 # [button:0x16c37dc type: button name:  value: No]
 # [button:0x16c3608 type: button name:  value: Cancel]}>}>

 #{forms
  #<Mechanize::Form
  # {name nil}
  # {method "POST"}
  # {action "/cgi-bin/webif/network.sh"}
  # {fields
  #  [hidden:0x3093f0 type: hidden name: submit value: 1]
  #  [text:0x30bd54 type: text name: wan_ipaddr value: 10.0.0.121]
  #  [text:0x30b700 type: text name: wan_netmask value: 255.255.0.0]
  #  [text:0x30b1c0 type: text name: wan_ipaddrDef value: 10.0.0.121]
  #  [text:0x30ad1c type: text name: wan_netmaskDef value: 255.255.0.0]
  #  [text:0x30ea6c type: text name: wan_gateway value: 10.0.0.1]
  #  [selectlist:0x30db84 type:  name: wan_ethernet_mode value: []]
  #  [selectlist:0x310770 type:  name: wan_proto value: []]}
  # {radiobuttons}
  # {checkboxes}
  # {file_uploads}
  # {buttons
  #  [submit:0x308fb8 type: submit name: action value: Save]
  #  [submit:0x30cae0 type: submit name:  value: Yes]
  #  [button:0x30c7ec type: button name:  value: No]
  #  [button:0x30c2e8 type: button name:  value: Cancel]}>}>
#<Mechanize::Form:0x60e0b8>

 #{forms
  #<Mechanize::Form
  # {name nil}
  # {method "POST"}
  # {action "/cgi-bin/webif/wireless-radio.sh"}
  # {fields
  #  [hidden:0x157acf4 type: hidden name: submit value: 1]
  #  [text:0x157f194 type: text name: ap_mode_wifi0 value: 802.11 b/g/n]
  #  [selectlist:0x1587bdc type:  name: country_wifi0 value: []]
  #  [selectlist:0x15cf3cc type:  name: ht_mode_wifi0 value: []]
  #  [selectlist:0x163365c type:  name: bgchannel_wifi0 value: []]
  #  [selectlist:0x1634928 type:  name: txpower_wifi0 value: []]}
  # {radiobuttons
  #  [radiobutton:0x157ffc8 type: radio name: disabled_wifi0 value: 0]
  #  [radiobutton:0x157f8d8 type: radio name: disabled_wifi0 value: 1]}
  # {checkboxes}
  # {file_uploads}
  # {buttons
  #  [submit:0x157a9d0 type: submit name: action value: Save]
  #  [submit:0x157a4b4 type: submit name:  value: Yes]
  #  [button:0x157a1cc type: button name:  value: No]
  #  [button:0x1580bec type: button name:  value: Cancel]}>}>
#<Mechanize::Form:0x2aeda08>

#main end