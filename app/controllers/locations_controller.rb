class LocationsController < ApplicationController
 


  def index
    @title = 'Locations Index'
    @current_location =gpslocation()
    @locations = Location.all
    
    if  @current_location != nil then 
        @exactly_at=nil
        @locations.each do |checklocation| 
        if @current_location.distance_to(checklocation) < checklocation.radius then
          @exactly_at =  checklocation
          @playstartsound=@playstartsound||false  
           if app_set('AutomatedTests') then
            #TODO Exec Testes
            if !@playstartsound then
              command = app_set('playerpath')+app_set('playerexec')+' '++app_set('wavfolder')+app_set('teststartwav')
              cmd=a.app_set('playerpath')+a.app_set('playerexec')+' '+a.app_set('wavfolder')+a.app_set('teststartwav')
               pid = Process.spawn( command )
            else
              @playedstartsound=true
            end  
          end  
          break;
        end  #if
      end #do
      @playstartsound=false  if @exactly_at==nil 
    end #nil
    if params[:search].present?
      @locations = Location.near(params[:search], 50, :order => :distance)||Location.all
    else
      @locations = Location.all
    end
  end


  def show
    @title = 'Showing location'
    @location = Location.find(params[:id])
    @locations = Location.near(params[:search], 50, :order => :distance)
    @locations.each do |nearlocation|
        nearlocation.bearing = Location.bearing(params[:search])
    end 
  end

  def gpslocation()
    mygpslocation = Location.new
    line_id=0;
    gps1 = Hash.new
    gps2 = Hash.new
    gps_error=true
    IO.popen(app_set('gpscommand')) { |myfile| 
         while (line= myfile.gets) do 
            if line.include?("[ERROR]") then
               gps1=nil
               gps2=nil
               gps_error=true
               mygpslocation.title = nil
               myfile.close
               break
            else   
              gps_error=false
            end
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
          end #while
        } #io
    if (gps2!=nil  && !gps_error) then
      mygpslocation.latitude =  (gps2[:lat]||0.0).to_f
      mygpslocation.longitude =  (gps2[:lng]||0.0).to_f
    end
    if (gps1!=nil && !gps_error) then
      mygpslocation.lastvisit =  DateTime.parse( [gps1[:day], gps1[:month], gps1[:year], gps1[:time]].join(' '))||DateTime.now()
    else
      mygpslocation.lastvisit =  DateTime.now()
      mygpslocation.title = 'Can\'t connect to gps'
    end
    if gps_error then
       return nil
    else   
       return mygpslocation
    end  
  end  

  def new
    @title = 'Showing location'
    @location = gpslocation()||Location.new
    @location.radius = app_set('defaultRadius')
  end

  def create
    @location = Location.new(params[:location])
    if @location.save
      redirect_to @location, :notice => "Successfully created location."
    else
      render :action => 'new'
    end
  end

  def edit
    @title = 'Edit location'
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      redirect_to @location, :notice  => "Successfully updated location."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    redirect_to locations_url, :notice => "Successfully destroyed location."
  end
end
