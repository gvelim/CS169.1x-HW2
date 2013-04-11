class Movie < ActiveRecord::Base

  # define Class method (static)
  def self.ratings_cache

    #if not cached before then
    if !defined? @@rating_keys then
      
      #create a static cache object
      @@rating_keys = {}
      # get uniq movie objects
      self.select(:rating).uniq.each do |movie|
        # capture the uniq rating values
        @@rating_keys[movie.rating] = false
      end
    end

    return @@rating_keys

  end
  
end
