customer_data = JSON.parse(File.read('db/seeds/customers.json'))

customer_data.each do |customer|
  Customer.create!(customer)
end

JSON.parse(File.read('db/seeds/movies.json')).each do |movie_data|
  movies = MovieWrapper.search(movie_data["title"])
  ap "#{movie_data['title']} Added to the library!"
  movies.first.inventory = movie_data['inventory']
  movies.first.save unless movies.empty?
end
