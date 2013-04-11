class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # first time load state from cache structure
    @all_ratings = Movie.ratings_cache
   
    # if any rating selected then update ratings state
    if params[:ratings] then
      
      params[:ratings].each do |key, value|
        @all_ratings[key] = true  
      end
      session[:filter] = @all_ratings.select { |k,v| v==true }.keys
    end
    
    @orderby = params[:o]
    @movies = Movie.where( :rating=>session[:filter] ).order( @orderby ).all
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
