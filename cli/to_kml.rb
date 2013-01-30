# copy and paste the code and save as a ruby file (.rb extension). Works with ruby 1.8.7 (default version on Snow Leopard).
# With the CSV file containing the data, run the script with the following syntax:
# ruby to_kml.rb <clientname> <filename> [optional write mode (w,wb,a+)] [optional output filename]
# So if this was for ATS Group, and the file was locations.csv:
# ruby to_kml.rb ATS_Group locations.csv
#
# CSV Formatting requirements:
#
# Must contain columns: name, address, lat, lng. You may leave other columns in there if you wish. There is no downfall to doing so.
# To get lat/lng values, use the address or zipcode data that you have, and paste it into the form here: out2launchdigital.com/pagetorrent/geocoder/
# Once the page linked is done, it will respond with an alert message. It will take time, as it runs a request to google's api every few seconds.

require 'csv'
require 'optparse'
require 'rgeo'

DOCTYPE = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n
           <kml xmlns=\"http://www.opengis.net/kml/2.2\"\n
		   xmlns:gx=\"http://www.google.com/kml/ext/2.2\"\n
		   xmlns:kml=\"http://www.opengis.net/kml/2.2\"\n
		   xmlns:atom=\"http://www.w3.org/2005/Atom\">"

 @options = Hash.new

 @options[:client_name] = 'ATS';
 @options[:inputfile] = 'c:\temp\output.csv';
 @options[:writemode] = 'w';
 @options[:myfilename] = 'c:\temp\kml_output.kml'; 
 @options[:usetimestamp] = true; 

  
     
 
 opts = OptionParser.new do |opts|
    opts.banner = 'To KML'

    opts.on("-c", "--clientname [client_name]", "Client name to add to header") do |client_name|
      @options[:client_name] = client_name
    end

    opts.on("-i", "--inputfile [inputfile]", "File with full path to translate") do |inputfile|
      @options[:inputfile] = inputfile
    end
    
	opts.on("-w", "--writemode [option]", "append (a+) or overwrite (w) new output file") do |wm|
      @options[:writemode] = wm
    end
		
	opts.on("-o", "--outputfile [filename]", "Target File with path to create") do |outputfilename|
      @options[:myfilename] = outputfilename
    end
	
	opts.on("-u", "--usetimestamp true/false", "should the kml have timestamps or not") do |ts|
      @options[:usetimestamp] = ts
    end
	
	opts.on("-h", "--help", "-?", "--?", "Get Help") do |help|
      puts("help ..... call oz 052-5528022")
	  puts opts.help
    end
  
end		   



  if ARGV.length == 0
    puts opts.help 
  else
   opts.parse!(ARGV)  
 end
 


Colors=Array['00FF00',	'00FF1F',	'00FF3F',	'00FF5F',	'00FF7F',	'00FF9F',	'00FFBF',
	'00FFDF',	'00EFFF',	'00CFFF',	'00AFFF',	'008FFF',	'006FFF',	'004FFF','002FFF','0000FF']

@rss_styles = Array.new [ -25,-30,-35,-40,-45,-50,-55,-60,-65,-70,-75,-80,-85,-90,-95 ]  

unless File.exists?(@options[:inputfile])
  raise 'File not found'
end
name, address,timestamp, lat, lng,client = nil,nil,nil,nil,nil,nil
def file_is_valid(row)
  if ((row==nil) || (row =="")) then
	return false
  end
  #row = row.collect {|c| c.downcase }
 # puts row;
 # puts row.include?('name'); 
 # puts row.include?('address'); 
 # puts row.include?('lat');
 # puts row.include?('lng');
 # puts row.include?('timestamp');
 row.include?('name') && row.include?('address') && row.include?('lat') && row.include?('lng') && row.include?('timestamp');
end

def humanize(str)
  str.gsub(/\-/, ' ')
end

 @locations = []

class Location
  attr_accessor :name, :address, :lat, :lng, :client, :timestamp
  
  
  def initialize(myoptions = {})

    if myoptions.size > 0
      	
      @name = myoptions[:name]
      @address = myoptions[:address]
      @lat = myoptions[:lat]
      @lng = myoptions[:lng]
      @client = myoptions[:client]
      @timestamp = myoptions[:timestamp]
	  
    end
  

  def to_kml
    uts = false 
    displayname = false
    out=" <Placemark>\n"+
        "   <name>"
        out +=  "#{@name}" unless !displayname
        out += @timestamp[11..18] unless !uts
        out +="</name>\n"   #postion
       #"   <TimeStamp><when>#{@timestamp}</when></TimeStamp>\n" 
	  if uts then
        out += "   <TimeStamp>#{@timestamp}</TimeStamp>\n" 
	  end	
	out += "   <visibility>1</visibility>\n"+
		#"   <open>1</open>\n" +
		#"<LookAt>\n" +
		#"	<longitude>#{@lng}</longitude>\n" +
		#"	<latitude>#{@lat}</latitude>\n"+
		#"	<altitude>0</altitude>\n"+
		#"	<heading>0</heading>\n"+
		#"	<tilt>0</tilt>\n"+
		#"	<altitudeMode>relativeToGround</altitudeMode>\n" +
		#"	<gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>\n"+
		#"</LookAt>\n" +
		""
      index=0;
      style_index ='';
	  rss_styles = Array.new [ -25,-30,-35,-40,-45,-50,-55,-60,-65,-70,-75,-80,-85,-90,-95 ]  
      rss_styles.each do |rss_level|
        #puts ("#{@address.to_i} < #{rss_styles[index].to_i} = #{(@address.to_i < rss_styles[index].to_i)}")
        if @address.to_i <= rss_styles[index].to_i then 
          style_index = (index==0)? '': index.to_s;
        end
	    index+=1
      end
    out += "	<styleUrl>#msn_shaded_dot#{style_index}</styleUrl>\n"
    out += "	<description>RSS=#{@address}</description>\n"+
         "   <Point>\n"+
         "     <coordinates>#{@lng},#{@lat}</coordinates>\n"+
         "   </Point>\n"+
        " </Placemark>\n"
     out.gsub(/\&/, '&amp;')
   end #def
 end
  
end

 first = true
 rows=0
 
  puts @options
  puts ("parsing #{@options[:inputfile]} into #{@options[:myfilename]}")
 CSV.foreach(@options[:inputfile]) do |row|
  rows+=1
  if first 
    first = false

	if !file_is_valid(row)
	   puts ("file[#{@options[:inputfile]}] has bad header")
	   puts row
       raise "File is missing a required header. Must have columns of: name, address, lat, lng"
    else
      row.each_with_index do |col_name, i|
        case col_name.to_s.downcase
      when 'name' 
        name = i
	    puts ("name in col:#{i}");
	  when 'address'
	    address = i
        puts ("address in col:#{i}");
      when 'timestamp'
		timestamp = i
		puts ("timestamp in col:#{i}");
	  when 'lat'
		lat = i
		puts ("lat in col:#{i}");
	  when 'lng'
	    puts ("lng in col:#{i}");
	    lng = i
	  when 'client'
		puts ("client in col:#{i}");
		client = i
      end
      end
    end

  else
    @locations << Location.new(:name => "#{rows}@", :address => row[address], :lat => row[lat], :lng => row[lng], :client => row[client], :timestamp => row[timestamp])
  #  puts @locations.last.to_kml
    
  end
  
end
 #puts @locations.each.to_kml

 
 File.open(@options[:myfilename], @options[:writemode]) do |f|
  f.write(DOCTYPE + "\n" + "<Document>\n"+ " <name>SmallCloud</name>\n")
 
  
  id=''
  Colors.each do |color|
    f.write("  <Style id=\"sn_shaded_dot#{id}\">\n")
    f.write("   	<IconStyle>\n")
    f.write("     		<color>FF#{color}</color>\n") #red
    f.write("     		<scale>0.5</scale>\n")
    f.write("     		<Icon>\n")
    f.write("        		<href>http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png</href>\n")
    f.write("     		</Icon>\n")
    f.write("   	</IconStyle>\n")    
    f.write("   	<ListStyle>\n")
	f.write("   	</ListStyle>\n")
    f.write("  </Style>\n")
	f.write("  <Style id=\"sh_shaded_dot#{id}FF\">\n")
    f.write("   	<IconStyle>\n")
    f.write("     		<color>FF#{color}</color>\n") #red
    f.write("     		<scale>0.8</scale>\n")
    f.write("     		<Icon>\n")
    f.write("        		<href>http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png</href>\n")
    f.write("     		</Icon>\n")
    f.write("   	</IconStyle>\n")    
    f.write("   	<ListStyle>\n")
	f.write("		</ListStyle>\n")
    f.write("  </Style>\n")
    id=(id=='')? 0: id + 1;
 
    index=''
    @rss_styles.each do |rss_level|
      f.write("<StyleMap id=\"msn_shaded_dot#{index}\">\n")  
      f.write("     <Pair>\n")
      f.write("       <key>normal</key>\n")
      f.write("       <styleUrl>#sn_shaded_dot#{index}</styleUrl>\n")
      f.write("     </Pair>\n")
	  f.write("    <Pair>\n")
	  f.write("      <key>highlight</key>\n")
      f.write("      <styleUrl>#sh_shaded_dot#{index}</styleUrl>\n")
      f.write("    </Pair>\n")
	  f.write("</StyleMap>\n")
	  index=(id=='')? 0: index.to_i + 1;
	end  
    
    end   
   geofactory = RGeo::Geographic.spherical_factory 
   my_lat = @locations[0].lat.gsub(/[N]/,'')
   my_lng = @locations[0].lng.gsub(/[E]/,'')
   start_loc= geofactory.point(my_lat,my_lng)
#   puts loc0
   index=0
  @locations.each do |location|
    f.write("#{location.to_kml}\n")
    index+=1
    # myloc =  geofactory.point(location.lat,location.lng)	
    # puts ("distance to start #{index}:"+myloc.distance(loc0).to_s)
#    puts Time.now().strftime("Now is %H:%M:%S.%3N")
  end

  f.write("</Document>\n</kml>")
 end

