class FluxaliserController < ApplicationController
    
  def initialize
  end

  def index
  end
  
  def results    
    @photos = Array.new
    
    if params[:flickr_username].nil?
      redirect_to :action => :index
    else    
      if !params[:flickr_username].empty?
        @flickr_username = params[:flickr_username]
        @destination = (params[:destination][:year] + "-" + params[:destination][:month] + "-" + params[:destination][:day]).to_date
      
        @photos = Fluxaliser.get_flickr_photos(flickr_username = @flickr_username, destination = @destination)
      else
        flash.now[:notice] = "You didn't enter a username! Go back and <a href='/'>try again</a>!"
        @destination = (params[:destination][:year] + "-" + params[:destination][:month] + "-" + params[:destination][:day]).to_date
      end
    end
  end
  
end
