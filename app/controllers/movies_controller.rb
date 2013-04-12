class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # load cache structure with keys -> false
    @all_ratings = Movie.ratings_cache
    debugger
    # if first time filter set all visible
    # if filter data sent with GET extract them otherwise set all checked#
    @filter = params.has_key?(:filter) ? params[:filter].split(':') : (session[:filter] || @all_ratings.keys) 
    
    # if any rating changes set relevant keys -> true
    if params.has_key? :commit then
      if params.has_key? :ratings then 
        session[:filter] = @filter = params[:ratings].keys
       else
        @filter = session[:filter]
      end
    end

    @orderby = params[:o]
    @movies = Movie.where( :rating => @filter ).order( @orderby ).all

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
