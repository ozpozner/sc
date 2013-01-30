class RadiosController < ApplicationController
  helper_method :new_wifi
 
  def index
    @radios = Radio.all
    crawl
  end
  
  def crawl
    @wifir=Radio.new
    @hmu=Radio.new
    @hbs=Radio.new
  end

  def show
    @radio = Radio.find(params[:id])
  end

  def new
    @radio = Radio.new
  end

  def new_wifi
    @radio = Radio.new
    netsh=WifiController.pc_netsh
    @radio.mac = netsh('bssid')
  end

  def create
    @radio = Radio.new(params[:radio])
    if @radio.save
      redirect_to @radio, :notice => "Successfully created radio."
    else
      render :action => 'new'
    end
  end

  def edit
    @radio = Radio.find(params[:id])
  end

  def update
    @radio = Radio.find(params[:id])
    if @radio.update_attributes(params[:radio])
      redirect_to @radio, :notice  => "Successfully updated radio."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @radio = Radio.find(params[:id])
    @radio.destroy
    redirect_to radios_url, :notice => "Successfully destroyed radio."
  end
end
