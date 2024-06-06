class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.distinct.pluck(:rating) #returns an array of all unique ratings present in the "movies" table.
    # @ratings_to_show_hash = params[:ratings] || {} ##incoming ratings from form in hash 
    # #params[:ratings] = { "G" => "1", "PG" => "1", "R" => "1" }
    # @sort_column = params[:sort] ##if sort parameter is requested in the URL it keeps which column in the variable

    # If params[:ratings] is present, use it, otherwise use session[:ratings] if it exists
    # Check if the form was submitted as if nothing is chosen in the tick box it will not get a request hence no chnages
    if params[:form_submitted]
      @ratings_to_show_hash = params[:ratings] || {}
      session[:ratings] = @ratings_to_show_hash
    elsif session[:ratings]
      @ratings_to_show_hash = session[:ratings]
    else
      @ratings_to_show_hash = {}
    end

    if params[:sort]
      @sort_column = params[:sort]
      session[:sort] = @sort_column
    elsif session[:sort]
      @sort_column = session[:sort]
    else
      @sort_column = 'title' # default sorting by title
    end

    if @ratings_to_show_hash.any?
      selected_ratings = @ratings_to_show_hash.keys
      @movies = Movie.with_ratings(selected_ratings) 
    else
      @movies = Movie.all
    end
    if @sort_column ## will order it if @sort_column has a specified column
      @movies = @movies.order(@sort_column)
    end

    @highlight_column = params[:sort] ## highlight it if incoming sort request
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
