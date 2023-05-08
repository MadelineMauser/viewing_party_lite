class MoviesController < ApplicationController
  def index
    if params[:search] == ""
      redirect_to '/discover'
    elsif params.include? 'search'
      @search_results = MovieSearch.new.search_movies(params[:search])
    else
      @search_results = MovieSearch.new.top_rated_movie_list
    end
  end

  def show
    @user = current_user
    @movie = MovieSearch.new.retrieve_movie(params[:id])
  end
end
