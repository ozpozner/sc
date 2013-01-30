#require 'ruby-gems'
require 'net/telnet'
require 'csv'
#require 'net/ping'
 


# file_name = File.join(RAILS_ROOT, 'public','csv',"#{start_date_f}_#{end_date_f}.csv")
# return file_name if File.exist?(file_name)
# @results = find(:all)
# header_row = []
# outfile = File.open(file_name, 'wb')
# CSV::Writer.generate(outfile) do |csv|
#      header_row = ['gateway_id','created', 'gateway_status_id', 'panel_id',  'panel_status','volts_out', 'amps_out', 'temp','aid' ,'sid', 'pisid']
#      csv << header_row
#  end

#move to INI File
  pingHosts = Hash.new
  pingHosts = {:WiFi => '10.0.0.121' , :BH => '10.0.5.120' , :HBS => '10.0.1.1', :remote => '10.0.0.31'};
  myhost = ARGV[0] ||pingHosts[:BH];
  myfile = ARGV[2] ||'c:\temp\output.csv';
  executions =  Integer(ARGV[1] || 10);
  pingResults = Hash.new;
  pingResults = {:WiFi => "N/A" , :BH => "N/A" , :HBS => "N/A", :remote => "N/A"};
  debug=true;
  debuglevel = 1;
  pings=true;
  PINGTIMEOUT = 50;
  Existingfileopenmode = 'a+'

  gps1      = Hash.new; 
  gps2      = Hash.new;
  bh        = Hash.new;
  bh_air    = Hash.new;
  bh_lan    = Hash.new;
  
   #bh = {:RSS => '0', :TX => '0', :RX=>'0'};
   bh = {:address => '0',
         :tx => '0',
         :client=>'0'};
   bh_air = { 
         :No => '0',
         :OK => '0',
         :UAS => '0',
         :ES => '0',
         :SES => '0',
         :BBE => '0',
         :MinRSL => '0',
         :MaxRSL => '0',
         :RSLTD1 => '0',
         :RSLTD2 => '0',
         :MinTSL => '0',
         :MaxTSL => '0',
         :TSLTD1 => '0',
         :BBERTD1 => '0'  };
   bh_lan = { 
         :No => '0',
         :OK => '0',
         :UAS => '0',
         :ES => '0',
         :SES => '0',
         :BBE => '0',
         :RxMBytes => '0',
         :TxMBytes => '0',
         :EthTHRUnder => '0',
         :HighTrEx => '0' };


#No|OK|UAS|ES |SES|BBE |MinRSL|MaxRSL|RSLTD1|RSLTD2|MinTSL|MaxTSL|TSLTD1|BBERTD1|
#1 |1 |0  |0  |0  |0   |-67   |-67   |0     |0     |-8    |-8    |0     |0      |
#
#
#Command "display PM AIR current" finished OK.
#
#admin@10.0.1.1-> display PM LAN1 current
#
#No|OK|UAS|ES |SES|BBE |RxMBytes |TxMBytes |EthTHRUnder |HighTrEx |
#1 |1 |0  |0  |0  |0   |0        |0        |0           |0        |
#
#startup validations
 
# netsh wlan show interfaces

def ping (host) 
  line_id=0;
  IO.popen("C:/Users/ozp/smallcloud/Fping.exe #{host} -t 2ms -o -w #{PINGTIMEOUT}") {
         |io| while (line = io.gets) do 
           # puts line
            line_id+=1;
            line_a = line.split(/\s+/)
           # puts line_a[1];
            if line_a[1]=="Minimum" then
              line_a = line.split(/\s+/)
             #  puts ("#{line_id} : #{line_a} ")
              return(line_a[11]||"-1")
            end
          end
        } #io
end

puts ("connect to device #{myhost}"+"  output file #{myfile}");
puts ("delay to HBS("+pingHosts[:HBS]+"): "+ping(pingHosts[:HBS])+" ms");
puts ("delay to monitored device(#{myhost}):"+ping(myhost)+" ms");

if (debug && debuglevel>4) then puts ("loggin to device") end
tn = Net::Telnet::new("Host"=>pingHosts[:HBS], "Timeout"=>5, "Output_log"=>"../log/output_log.log", "Dump_log"=> "../log/dump_log.log")

if (debug && debuglevel>4) then 
  puts tn 
  tn.login('admin', 'netman') { |c| print c } ;
else
  tn.login('admin', 'netman')
end    
if ping(pingHosts[:HBS]) == "0.0" then
    Puts ("can't connected to host aborting");
    exit;
end;    
index =0;

  #{day,month,day,time,year,lat,long,junk]
   
while (index < executions ) do
  begin
    line_id=0
  if (debug && debuglevel>4) then puts ("#{index}: gpslabel") end
  IO.popen('"C:\Program Files (x86)\GPSBabel\gpsbabel.exe" -i garmin,get_posn -f usb:') {
         |io| while (line = io.gets) do 
           # puts line
            line_id+=1;
            if line_id==1 then
             line_a = line.split(/\s+/,5)
             gps1 = {:week_day => line_a[0]||"",
                    :month => line_a[1||""],
                    :day => line_a[2]||"",
                    :time => line_a[3]||"",
                    :year => line_a[4][0..3]||"" }
            end
            if line_id==2 then
             line_a = line.split(/\s/,3)
             gps2 = {:lat => line_a[1]||"",
                    :lng => line_a[2][0..9]||"",
                    }
            end
          end
        } #io
  
       
  #puts gps1;
  #puts gps2;
  i=0
  level="unknown"
  if (debug && debuglevel>4) then puts ("#{index}: display link") end
  tn.cmd('display link') do |output|
    i=0;
    splitedoutput = output.split;
    splitedoutput.each do |sout|
      if sout=="RSS" then
        level = splitedoutput[i+1];
      end
     i=i+1
     end #sout     
   end #output
   li=0
  
   myparamid =0;
   hashkey=0;
   if (debug && debuglevel>4) then puts ("#{index}: display PM AIR current") end
     keys=bh_air.keys;
   tn.cmd('display PM AIR current') do |output|
      output.strip.split(/\s/).each do |line|
       line.strip.split('|').each do |line_param|
        level=line_param.match( /-{1}\d+/)||0;
        if ((level != 0) and (bh[:address]=='0')) then
          # puts ("#{li},#{myparamid}=#{level}")  
          myparamid +=1;
          bh [:address] = "#{level}".strip;
        end  #if RSS==0
        myparamid+=1;
        if (hashkey >=1 && hashkey <=14 && line_param!="") then
          bh_air[keys[hashkey-1]]=line_param;
          hashkey +=1;
        end
        if line_param == 'BBERTD1' then
          hashkey +=1;
        end  
        if (debug && debuglevel>4) then 
          puts line_param
        end
       end #line_param
      end #line
    end #telnet 'display PM AIR current' |output|
    if (debug && debuglevel>4) then
        puts bh
        puts bh_air
      end
    #puts bh;
    myparamid =0;
    hashkey =0;
    li =0;
    if (debug && debuglevel>4) then puts ("#{index}: display PM LAN1 current") end
    tn.cmd('display PM LAN1 current') do |output|
      keys=bh_lan.keys;
      li +=1;
        output.strip.split(/\s/).each do |line|
          line.strip.split('|').each do |line_param|
          myparamid +=1;
         # puts ("#{myparamid}==#{line_param}")
          
          if (hashkey >=1 && hashkey <=10 && line_param!="") then
            bh_lan[keys[hashkey-1]]=line_param;
            hashkey +=1;
            if (hashkey == 9) then
            bh[:TX] = "#{line_param} ".strip;
          end  
          if (hashkey == 10) then
            bh[:client] = "#{line_param} ".strip;
          end
          end
          if line_param == 'HighTrEx' then
            hashkey +=1;
          end  
          if (debug && debuglevel>4) then 
            puts line_param
          end
        end #line_param
      end #line  
    end #telnet 'display PM AIR current'
    if (debug && debuglevel>4) then
        puts bh
        puts bh_lan
      end
    if pings then
       pingHosts.each_key do |key|
         pingResults[key]=ping(pingHosts[key])
       end  
    if (debug && debuglevel>3) then puts pingResults end   
       
    end
    
    if (debug && debuglevel>4) then puts ("#{index}: CSV") end
    if index == 0 then
      CSV.open(myfile,  (File.exist?(myfile)? Existingfileopenmode : 'w') ) do |csv|
       csv_line="name, "; 
       gps1.each_key do |key|
         csv_line+="#{key}, "
       end  
       gps2.each_key do |key|
         csv_line+="#{key}, "
       end  
       bh.each_key do |key|
         csv_line+="#{key}, "
       end
       pingHosts.each_key do |key|
         csv_line+="ping to #{key}, "
       end
       bh_air.each_key do |key|
         csv_line+="BH_AIR_#{key}, "
       end      
       bh_lan.each_key do |key|
         csv_line+="BH_LAN_#{key}, "
       end      
       
       csv_line+="timestamp"
       csv << csv_line.split(/,\s/) 
      end #open CSV
    end #if index=1
    CSV.open(myfile,"a+") do |csv|
      csv_line="#{index}, "
      gps1.each_value do |value|
        csv_line+="#{value}, "
      end #gps1
      gps2.each_value do |value|
        csv_line+="#{value}, "
      end #gps2
      bh.each_value do |value|
        csv_line+="#{value}, "
      end #bh
      pingResults.each_value do |value|
        csv_line+="#{value}, "
      end #ping results
      bh_air.each_value do |value|
        csv_line+="#{value}, "
      end #bh_air
      bh_lan.each_value do |value|
        csv_line+="#{value}, "
      end #bh_lan
      #reformat timestamp 2013-01-14T12:50:43Z
      case gps1[:month]
      when 'Jan' 
        gps1[:month]='01'
      when 'Feb' 
        gps1[:month]='02'
      when 'Mar' 
        gps1[:month]='03'
      when 'Apr' 
        gps1[:month]='04'
      when 'May' 
        gps1[:month]='05'
      when 'Jun' 
        gps1[:month]='06'
      when 'Jul'
        gps1[:month]='07'
      when 'Aug' 
        gps1[:month]='08'
      when 'Sep' 
        gps1[:month]='09'
      when 'Oct' 
        gps1[:month]='10'
      when 'Nov' 
        gps1[:month]='11'
      when 'Dec' 
        gps1[:month]='12'
      end #case
      
      timestamp="#{gps1[:year]}-#{gps1[:month]}-#{gps1[:day]}T#{gps1[:time]}Z";
     # puts timestamp;
      csv_line += "#{timestamp}"
      csv << csv_line.split(/,\s/) 
    end #csv a+
  rescue
     @error_message="#{$!}";
     puts ("#{index}:"+Time.now.to_s+ " Caught error:"+@error_message)
    
  ensure
    if (debug && debuglevel>0) then puts( "end of #{index}/#{executions}: time now is ["+Time.now.to_s+"] host: "+pingHosts[:HBS]+" delay is:"+ping(pingHosts[:HBS])); end
    index +=1;
   end
  end #while
exit