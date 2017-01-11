require "yaml"
require "json"

MACCHI_VERBOSE = false

MACCHI_DATA_PATH = "macchi_data"
MACCHI_OUTPUT_FILENAME = "data/macchi_movies.json"
MACCHI_MOVIES_DATA_FILE = "movies.yaml"
MACCHI_MOVIES_DATA_PATH = "movies"

movies_info = YAML.load_file("#{MACCHI_DATA_PATH}/#{MACCHI_MOVIES_DATA_FILE}")
movies_output_file = File.open(MACCHI_OUTPUT_FILENAME, "w")

movies_info.each do |movie_info|
  puts movie_info if MACCHI_VERBOSE
  movies = YAML.load_file("#{MACCHI_DATA_PATH}/#{MACCHI_MOVIES_DATA_PATH}/#{movie_info["filename"]}")
  puts movies if MACCHI_VERBOSE
  movie_info["movies"] = []#movies if movies
  movies.each do |movie|
    if movie["title"] == nil
      movie["title"] = movie_info["name"]
      #movie_info["movies"] = movie_info["movies"]
      puts "Using chapter name as default movie title"
    end
  end
  movie_info["movies"] = movies
end

puts movies_info if MACCHI_VERBOSE

movies_output_file.write(JSON.pretty_generate(movies_info))
movies_output_file.close
