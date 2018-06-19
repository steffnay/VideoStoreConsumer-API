class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    if params[:query]
      data = MovieWrapper.search(params[:query])
    else
      data = Movie.all
    end

    render status: :ok, json: data
  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
        )
      )
  end

  def create
    new_movie = Movie.new(
      title: movie_params[:title],
      overview: movie_params[:overview],
      release_date: movie_params[:release_date],
      image_url: movie_params[:image_url],
      external_id: movie_params[:external_id])


    if new_movie.save
      render json: { external_id: new_movie.external_id }, status: :ok
      return
    else
      render json: {ok: false, errors: "Movie not added to inventory"}, status: :bad_request
      return
    end

  end

  private

  def require_movie
    @movie = Movie.where('lower(title) = ?', params[:title].downcase).first
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end

  def movie_params
    params.permit(:title, :overview, :release_date, :image_url, :external_id)
  end

end
