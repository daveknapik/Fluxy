require 'flickr_fu'

class Fluxaliser
  
  def initialize
  end
  
  def self.get_flickr_photos(flickr_username, destination)
    @f = Flickr.new(File.join(RAILS_ROOT, 'config', 'flickr.yml'))
    
    @photo_array = Array.new
    
    @min_taken_date = destination.to_s
    @max_taken_date = (destination + 1).to_s
    @found_photos_for_selected_date = false
    @showing_random_photos = false
    
    #use the username to get the user's flickr ID
    @flickr_nsid_hash = @f.people.find_by_username(flickr_username)
    @nsid = @flickr_nsid_hash.nsid
    
    #get the photos for that the selected user took on the selected date
    @photo_search_results = @f.photos.search("user_id" => @nsid, "min_taken_date" => @min_taken_date, "max_taken_date" => @max_taken_date)
    @total_photos = @photo_search_results.total
    @timeperiod = "on " + destination.strftime('%A, %e %B %Y')
    
    #if the user didn't take any photos that day, try to get photos taken within a week on either side of the selected date
    if @total_photos == 0
      @min_taken_date = (destination - 7).to_s
      @max_taken_date = (destination + 8).to_s
      
      @photo_search_results = @f.photos.search("user_id" => @nsid, "min_taken_date" => @min_taken_date, "max_taken_date" => @max_taken_date)
      @total_photos = @photo_search_results.total
      @timeperiod = "between " + (destination - 7).strftime('%A, %e %B %Y') + " and " + (destination + 8).strftime('%A, %e %B %Y');
      @found_photos_for_selected_date = false
    else
      @found_photos_for_selected_date = true
    end
    
    #if the user didn't upload any photos that day either, try to get photos taken within two weeks on either side of the selected date
    if @total_photos == 0
      @min_taken_date = (destination - 14).to_s
      @max_taken_date = (destination + 15).to_s
      
      @photo_search_results = @f.photos.search("user_id" => @nsid, "min_taken_date" => @min_taken_date, "max_taken_date" => @max_taken_date)
      @total_photos = @photo_search_results.total
      @timeperiod = "between " + (destination - 14).strftime('%A, %e %B %Y') + " and " + (destination + 15).strftime('%A, %e %B %Y');
      @found_photos_for_selected_date = false
    end
    
    #last chance fail safe: pick 5 random photos and show those
    if @total_photos == 0
      @photo_search_results = @f.photos.search("user_id" => @nsid, "per_page" => 5, "page" => 1)
      @total_photos = @photo_search_results.total
      @timeperiod = "random"
      @found_photos_for_selected_date = false
      @showing_random_photos = true
    end
    
    unless @total_photos == 0     
        @photos_array = @photo_search_results.photos
        
        #loop over @photos_array to build new hash of photo title, url and thumbnail url (display thumnbnail, link to url?)
        for photo in @photos_array 
          
          @photo_page = photo.url_photopage
          @photo_title = photo.title
          @photo_date_taken = photo.taken_at
          @photo_thumbnail = photo.url(:thumbnail)
          @photo_hash = {:title => @photo_title, :page => @photo_page, :thumbnail => @photo_thumbnail, :date_taken => @photo_date_taken, :timeperiod => @timeperiod, :found_photos_for_selected_date => @found_photos_for_selected_date, :showing_random_photos => @showing_random_photos}
          
          @photo_array << @photo_hash
        end
    end
    
    @photo_array.sort_by {|hash| hash[:date_taken]}
  end
  
end