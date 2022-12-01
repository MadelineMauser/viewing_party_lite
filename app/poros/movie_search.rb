require './app/services/tmdb_services'
require './app/poros/movie'

class MovieSearch

  def top_rated_movie_list
    movies = service.top_rated
    movies = movies[:results].first(20)
    movies.map { |movie_hash| Movie.new(movie_hash) }
  end

  def search_movies(query)
    movies = service.search_movies(query)
    movies = movies[:results].first(20)
    movies.map { |movie_hash| Movie.new(movie_hash) }
  end

  def retrieve_movie(movie_id)
    movie = service.get_movie(movie_id)
    Movie.new(movie)
  end

  def service
    TmdbService.new
  end
end