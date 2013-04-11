class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # load cache structure with keys -> false
    @all_ratings = Movie.ratings_cache
    
    # if first time filter set all visible
    # session[:filter] = @all_ratings.keys if !session[:filter]
    @filter = params.has_key?(:filter) ? params[:filter].split(':') : @all_ratings.keys 
    logger.debug "filter: " << @filter.to_s
    logger.debug "all_ratings(be4): " << @all_ratings.to_s
    logger.debug "params: " << params.to_s
    
    # if any rating changes set relevant keys -> true
    if params.has_key? :commit then
      if params.has_key? :ratings then
        params[:ratings].each_key { |key| @all_ratings[key] = true}
        # filter only keys -> true
        @filter = @all_ratings.select { |k,v| v==true }.keys
       else
        @filter = []
      end
    end

    @orderby = params[:o]
    @movies = Movie.where( :rating=>@filter ).order( @orderby ).all

    logger.debug "filter(after): " << @filter.to_s
    logger.debug "all_ratings (after): " << @all_ratings.to_s

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
