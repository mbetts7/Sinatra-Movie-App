require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
    erb :index
end

post '/result' do
    # map of ids or names to values.  whatever put into text box it is the value of the key :movie
    query = params[:movie]

    response = Typhoeus.get("http://www.omdbapi.com/", params: {s: query})
    # result we get back is just a string, not an object.  so parse
    result = JSON.parse(response.body)

    @movies = result["Search"].sort_by { |movie| movie["Year"] }
    
    erb :result
end
  

get '/poster/:imdb' do |imdb_id|

    response = Typhoeus.get("http://www.omdbapi.com/", params: {i: imdb_id})
    @movie = JSON.parse(response.body) #must set to @movie!!!!!!!!!!!!!

    erb :poster
end







  # # Make another api call here to get the url of the poster.
  
  # # result["Search"].each do |movie|
  # html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  # html_str = "<br> <img src =#{result["Poster"]}> <br>"
  # html_str += '<a href="/">New Search</a></body></html>'
