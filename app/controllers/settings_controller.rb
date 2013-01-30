require 'yaml'  
class SettingsController < ApplicationController
   helper_method :init
  
  def index
    @settings = Setting.all
  end
  
  def init
    file = (APP_CONFIG[Rails.env]['root']+'config\config.yml')||'c:\users\ozp\apps\sc\config\config.yml'
    newsettings = YAML.load(File.read(file))  
    id=0
    newsettings[Rails.env].each do |par|
      id+=1
       @newsetting = Setting.find_by_key(par[0])
        if @newsetting !=nil then
          @newsetting.value = par[1]
          @newsetting.save
        else
          @newsetting = Setting.new
          @newsetting.key = par[0]
          @newsetting.value = par[1]
          @newsetting.mytype =par[1].class.to_s
          @newsetting.save
        end 
      end  
     @settings = Setting.all
     return ("Update / Created:"+id.to_s) 
  end  

  def show
    @setting = Setting.find(params[:id])
  end

  def new
    @setting = Setting.new
  end

  def create
    @setting = Setting.new(params[:setting])
    if @setting.save
      redirect_to @setting, :notice => "Successfully created setting."
    else
      render :action => 'new'
    end
  end

  def edit
    @setting = Setting.find(params[:id])
  end

  def update
    @setting = Setting.find(params[:id])
    if @setting.update_attributes(params[:setting])
      redirect_to @setting, :notice  => "Successfully updated setting."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @setting = Setting.find(params[:id])
    @setting.destroy
    redirect_to settings_url, :notice => "Successfully destroyed setting."
  end
end
