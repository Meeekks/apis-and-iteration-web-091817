require 'rest-client'
require 'json'
require 'pry'

def get_character_info(character)
  page_counter = 0
  character_hash = {}

  while (character_hash == {} && page_counter <= 8)
    page_counter += 1
    character_info = RestClient.get("http://www.swapi.co/api/people/?page=#{page_counter}")
    character_info_parsed = JSON.parse(character_info)

    character_info_parsed["results"].each do |elements|

      if elements["name"].downcase == character
        character_hash = elements
      end

    end

  end

  character_hash
end


def get_character_movies_from_api(character)
  #make the web request

  # all_characters = RestClient.get("http://www.swapi.co/api/people/?page=#{page_counter}")
  # character_hash = JSON.parse(all_characters)

  # iterate over the character hash to find the collection of `films` for the given
  #   `character`
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.

  movie_hash = []
  character_info = get_character_info(character)

  if character_info == {}
    return {}
  end

  character_info["films"].each do |element|
    movie_info = RestClient.get(element)
    movie_info_parsed = JSON.parse(movie_info)
    movie_hash.push(movie_info_parsed)
  end

  movie_hash
end


def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  if films_hash == {}
    return puts "Sorry, that is not a valid character."
  end

  movie_array = []

  films_hash.each do |movies_array|
    movie_array.push(movies_array["title"])
  end

  puts movie_array
end


def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end


## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
