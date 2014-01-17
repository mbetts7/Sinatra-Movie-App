require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
  html = %q(
  <html><head><title>Movie Search</title></head><body>
  <h1>Find a Movie!</h1>
  <form accept-charset="UTF-8" action="/result" method="post">
    <label for="movie">Search for:</label>
    <input id="movie" name="movie" type="text" />
    <input name="commit" type="submit" value="Search" /> 
  </form></body></html>
  )
end

post '/result' do
  # map of ids or names to values.  whatever put into text box it is the value of the key :movie
  query = params[:movie]

  
  # params is not a ruby thing, it is _______________
  response = Typhoeus.get("http://www.omdbapi.com/", :params => {:s => query})
  # result we get back is just a string, not an object.  so parse
  result = JSON.parse(response.body)

  movie_arr = []
  result["Search"].each do |movie| 
    movie_arr << [movie["Year"], movie["Title"], movie["imdbID"]]
  end
  
  movie_arr.sort!

  

  # Modify the html output so that a list of movies is provided.
  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1><ul>"
  movie_arr.each do |movie|
    html_str += "<li><a href = /poster/#{movie[2]}> #{movie[1]}, #{movie[0]}</a></li>"
  end
  

  html_str << "</ul></body></html>"
end

# <a href = "/poster/:imdb"> 




get '/poster/:imdbID' do |imdb_id|
  # Make another api call here to get the url of the poster.
  response = Typhoeus.get("http://www.omdbapi.com/", :params => {:i => imdb_id})
  result = JSON.parse(response.body)
  # result["Search"].each do |movie|
  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  html_str = "<br> <img src =#{result["Poster"]}> <br>"
  html_str += '<a href="/">New Search</a></body></html>'


end