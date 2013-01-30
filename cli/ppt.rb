  require 'date' 
  require 'csv' 
  def list
    
    @dirs = []
    @files = []
    @current_path ='.'
    @public_path="."
    Dir.glob(@current_path).sort.each do |file|
      file_obj = {
          #:url => file.gsub(@public_path, ''),
          :name => File.basename(file),
        }
      if File.directory?(file)
        @dirs << file_obj
      else
        @files << file_obj
      end
    end
    puts @files
    puts @dirs
  end
  
  def parsepathtest (filename)
    fileObj = File.new(filename, "r")
    lines=0
    paramid = 0
    #pathtest =Hash.new
    @pathtest[:created]=  File.ctime(filename)
    @pathtest[:modifed]=  File.mtime(filename)
    @pathtest[:accessed]= File.atime(filename)
    @pathtest[:jd] = File.atime(filename).to_i
    (@start==0)? @start= @pathtest[:jd] : @last=@pathtest[:jd]
    while (line = fileObj.gets)
      lines+=1
      out = line.split
      sline =""
      out.each do |param|
        paramid+=1
        sline += " [#{paramid}]"+param
        case paramid
        when 5
          @pathtest[:Protocol]=param
        when 22
          @pathtest[:bw]=param
        when 98
          @pathtest[:sentpackets]=param.to_i
          @sent+=@pathtest[:sentpackets]  
        when 100
          @pathtest[:recievpackets]=param.to_i
          @recived+=@pathtest[:recievpackets]  
          @pathtest[:LostPackets]=@pathtest[:sentpackets].to_i-param.to_i
          @lost += @pathtest[:LostPackets]
          @maxlost = (@maxlost>=@pathtest[:LostPackets])? @maxlost : @pathtest[:LostPackets]
        when 102
          @pathtest[:duration]=param  
        end
          
          
      end
     # puts("line[#{lines}]"+sline)
      
     end
     #puts pathtest
    fileObj.close
    return @pathtest
  end
  @pathtest=Hash.new
  puts "starting ppt"
  count=0
  @sent=0
  @recived=0
  @lost=0
  @maxlost=0
  @start=0
  myfile='c:\temp\pings.csv'
  files=0
  Existingfileopenmode = 'wb'
   CSV.open(myfile,  (File.exist?(myfile)? Existingfileopenmode : 'w') ) do |csv|
     Dir.glob("C:/Users/Guest/smallcloud/logs/*").sort.each do |file|
    if !File.directory?(file) then
      
      filename =File.basename(file)
      size = File.size(file)
      if (size > 0) && filename.match(/pathtest\d*.txt/) then
        files+=1
        #puts ("parsing " + filename)
        parsepathtest (file)
        #puts @pathtest
        if (files==1) then
          csv_line = "id, filename, "
          @pathtest.each_key do |key|
            csv_line+="#{key}, "
          end
          csv << csv_line.split(/,\s/)
        end
          csv_line = "#{files}, #{filename}, "
          @pathtest.each_value do |value|
            csv_line+="#{value}, "
          end
          csv << csv_line.split(/,\s/)
        end
               
       
       
        #(count<100) ? count+=1 : exit
      end
    end
   end
   ratio=@lost/@sent.to_f*100
puts ("sent:#{@sent.to_s} recived:#{@recived.to_s} lost:#{@lost} ratio:"+ratio.to_s+"% max lost:"+@maxlost.to_s)
puts "total run seconds:"+(@last-@start).to_s
