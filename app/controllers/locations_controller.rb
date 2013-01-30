class LocationsController < ApplicationController
 


  def index
    @title = 'Locations Index'
    if params[:search].present?
      @locations = Location.near(params[:search], 50, :order => :distance)
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

  def new
    @title = 'Showing location'
    @location = Location.new
    line_id=0;
    gps1 = Hash.new
    gps2 = Hash.new
    IO.popen('"C:\Program Files (x86)\GPSBabel\gpsbabel.exe" -i garmin,get_posn -f usb:') {
    #File.open('c:\users\ozp\gps.txt') { 
      |myfile| 
         while (line= myfile.gets) do 
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
    if gps2!=nil then
      @location.latitude =  (gps2[:lat]||0.0).to_f
      @location.longitude =  (gps2[:lng]||0.0).to_f
    end
    if gps1!=nil then
      @location.lastvisit = DateTime.parse( [gps1[:day], gps1[:month], gps1[:year], gps1[:time]].join(' '))||DateTime.now()
    end
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
