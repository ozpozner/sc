require 'mechanize'

class WifiController < ApplicationController

  def pc_netsh
    out = Hash.new
    cmd = app_set('wifi_netsh_cmd')
    #puts ("running command:#{cmd}")
    IO.popen(cmd) {
         |io| while (line = io.gets) do 
            #puts line
            out.store( 'ssid' , line.gsub(/\s/,'').gsub(/SSID:/,'') ) if ((line.include? "SSID") && !(line.include? "BSSID"))
            out.store( 'bssid' , line.gsub(/\s/,'').gsub(/BSSID:/,'') ) if line.include? "BSSID"
            out.store( 'profile' , line.gsub(/\s/,'').gsub(/Profile:/,'') ) if line.include? "Profile"
            out.store( 'signal' , line.gsub(/\s/,'').gsub(/Signal:/,'') ) if line.include? "Signal"
            out.store( 'channell' , line.gsub(/\s/,'').gsub(/Channel:/,'') ) if line.include? "Channel"
            out.store( 'radio_type' , line.gsub(/\s/,'').gsub(/Radiotype:/,'') ) if line.include? "Radio"
            out.store( 'nic_mac' , line.gsub(/\s/,'').gsub(/Physicaladdress:/,'') ) if line.include? "Physical"
          end   
        } #io
        return out
  end #apip  

  def p( mystring) 
    puts mystring+"11"
  end  

  def setup
    @agent = Mechanize.new
    @wifihost=app_set('wifihost')||'10.0.0.121'
  # @agent.ca_file = 'c:\Users\ozp\apps\smallcloud\app\games\curl-ca-buncle.crt'
  # @agent.agent.http.ca_file = 'lib/curl-ca-bundle.crt'
    @cert_store = OpenSSL::X509::Store.new
    @cert_store.add_file (app_set('root')+'lib\ca-cert.pem')
    @agent.agent.http.ca_file=app_set('root')+'lib\curl-ca-buncle.crt'
    @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @agent.add_auth("http://#{@wifihost}/",'admin','wireless')
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
 def main
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
  end #main

end
