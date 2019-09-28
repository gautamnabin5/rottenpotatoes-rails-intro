class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    orderBy = params[:orderBy] == nil ? session[:orderBy] : params[:orderBy] #retrieve order
    ratings = params[:ratings] == nil ? session[:ratings] : params[:ratings] #retrieve ratings
    @movies = Movie.with_rating!(Movie.all, ratings) # filter by rating first
    @movies = Movie.order_movies!(@movies, orderBy) # then order the list
    @all_ratings = Movie.get_all_ratings()
    @selected_ratings = Movie.extract_ratings_from_hash(ratings)
    @sort_order = orderBy
    # update session
    needsUrlChange = false
    if(session[:orderBy] != params[:orderBy])
      session[:orderBy] = params[:orderBy] if params[:orderBy] != nil
      needsUrlChange = true
    end
    if (session[:ratings] != params[:ratings])
      session[:ratings] = params[:ratings] if params[:ratings] != nil
      needsUrlChange = true
    end
    if needsUrlChange
      redirect_to action: "index", orderBy: session[:orderBy], ratings: session[:ratings]
    end
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

end
