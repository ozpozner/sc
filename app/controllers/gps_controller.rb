class GpsController < ApplicationController
  def index
    @gps = Gps.all
  end

  def show
    @gps = Gps.find(params[:id])
  end

  def new
    @gps = Gps.new
  end

  def create
    @gps = Gps.new(params[:gps])
    if @gps.save
      redirect_to @gps, :notice => "Successfully created gps."
    else
      render :action => 'new'
    end
  end

  def edit
    @gps = Gps.find(params[:id])
  end

  def update
    @gps = Gps.find(params[:id])
    if @gps.update_attributes(params[:gps])
      redirect_to @gps, :notice  => "Successfully updated gps."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @gps = Gps.find(params[:id])
    @gps.destroy
    redirect_to gps_url, :notice => "Successfully destroyed gps."
  end
end
