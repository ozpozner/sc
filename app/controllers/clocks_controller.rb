class ClocksController < ApplicationController
 

 def index
  @time_now=Time.now.strftime("%H:%M:%S.%3N")
  if @time_now =~/ (\d\d:\d\d:\d\d.\d\d\d)/
    @time_now=$1
  end
end

 # def index
 #   @clocks = Clock.all
 # end

  def show
    @clock = Clock.find(params[:id])
  end

  def new
    @clock = Clock.new
  end

  def create
    @clock = Clock.new(params[:clock])
    if @clock.save
      redirect_to @clock, :notice => "Successfully created clock."
    else
      render :action => 'new'
    end
  end

  def edit
    @clock = Clock.find(params[:id])
  end

  def update
    @clock = Clock.find(params[:id])
    if @clock.update_attributes(params[:clock])
      redirect_to @clock, :notice  => "Successfully updated clock."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @clock = Clock.find(params[:id])
    @clock.destroy
    redirect_to clocks_url, :notice => "Successfully destroyed clock."
  end
end
