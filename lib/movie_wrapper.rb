class MovieWrapper
  BASE_URL = "https://api.themoviedb.org/3/"
  KEY = ENV["TMDB_KEY"]

  BASE_IMG_URL = "https://image.tmdb.org/t/p/"
  DEFAULT_IMG_SIZE = "w185"
  DEFAULT_IMG_URL = "http://lorempixel.com/185/278/"

  def self.search(query)
    url = BASE_URL + "search/movie?api_key=" + KEY + "&query=" + query
    # puts url
    response =  HTTParty.get(url)
    if response["total_results"] == 0
      return []
    else
      movies = response["results"].map do |result|
        self.construct_movie(result)
      end
      return movies
    end
  end

  private

  def self.construct_movie(api_result)
    Movie.new(
      title: api_result["title"],
      overview: api_result["overview"],
      release_date: api_result["release_date"],
      image_url: api_result["poster_path"], #(api_result["poster_path"] ? self.construct_image_url(api_result["poster_path"]) : nil),
      external_id: api_result["id"])
  end

  def self.construct_image_url(img_name)
    return BASE_IMG_URL + DEFAULT_IMG_SIZE + img_name
  end

end
