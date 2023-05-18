class PartiesController < ApplicationController
  def new
    movie_search = MovieSearch.new
    @movie = movie_search.retrieve_movie(params[:movie_id])
    user = current_user
    @other_users = user.other_users
  end

  def create
    @party_host = current_user
    @movie = MovieSearch.new.retrieve_movie(params[:movie_id])
    @new_party = Party.new(party_params)
    @new_party[:movie_title] = @movie.title

    if (@new_party[:duration] >= @movie.runtime) && @new_party.save
      PartyUser.create(party_id: @new_party.id, user_id: @party_host.id, host: true)
      params[:users].each do |id|
        PartyUser.create(party_id: @new_party.id, user_id: id.to_i, host: false)
      end
      redirect_to controller: :users, action: :dashboard
    else
      flash[:alert] = "Party creation failed."
      redirect_to "/movies/#{params[:movie_id]}/parties/new"
    end
  end

  private

  def party_params
    params.permit(:duration, :date, :start_time)
  end
end
