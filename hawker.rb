require "yaml"
require "json"

HAWKER_VERBOSE = false

HAWKER_DATA_PATH = "hawker_data"
HAWKER_OUTPUT_FILENAME = "data/hawker_tours.json"
HAWKER_TOURS_DATA_FILE = "tours.yaml"
HAWKER_TOURS_DATA_PATH = "tours"

tours_info = YAML.load_file("#{HAWKER_DATA_PATH}/#{HAWKER_TOURS_DATA_FILE}")
tours_output_file = File.open(HAWKER_OUTPUT_FILENAME, "w")

# tours_info.each do |tour_info|
#   puts tour_info if HAWKER_VERBOSE
#   tours = YAML.load_file("#{HAWKER_DATA_PATH}/#{HAWKER_TOURS_DATA_PATH}/#{movie_info["filename"]}")
#   puts movies if HAWKER_VERBOSE
#   movie_info["movies"] = []
#   movies.each do |movie|
#     if movie["title"] == nil
#       movie["title"] = movie_info["name"]
#       puts "Using chapter name as default movie title" if HAWKER_VERBOSE
#     end
#   end
#   movie_info["movies"] = movies
# end
#
#puts movies_info if HAWKER_VERBOSE

tours_output_file.write(JSON.pretty_generate(tours_info))
tours_output_file.close
