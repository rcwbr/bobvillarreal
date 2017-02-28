require "yaml"
require "json"

BLOCH_VERBOSE = false

BLOCH_DATA_PATH = "bloch_data"
BLOCH_OUTPUT_FILENAME = "data/bloch_slideshows.json"
BLOCH_SLIDESHOWS_DATA_FILE = "slideshows.yaml"
BLOCH_SLIDESHOWS_DATA_PATH = "slideshows"

slideshows_info = YAML.load_file("#{BLOCH_DATA_PATH}/#{BLOCH_SLIDESHOWS_DATA_FILE}")
slideshows_output_file = File.open(BLOCH_OUTPUT_FILENAME, "w")

# slideshows_info.each do |slideshow_info|
#   puts slideshow_info if BLOCH_VERBOSE
#   slideshows = YAML.load_file("#{BLOCH_DATA_PATH}/#{BLOCH_SLIDESHOWS_DATA_PATH}/#{slideshow_info["filename"]}")
#   puts slideshows if BLOCH_VERBOSE
#   slideshow_info["slideshows"] = []
#   slideshows.each do |slideshow|
#     if slideshow["title"] == nil
#       slideshow["title"] = slideshow_info["name"]
#       puts "Using chapter name as default slideshow title" if BLOCH_VERBOSE
#     end
#   end
#   slideshow_info["slideshows"] = slideshows
#   slideshow_info["content_name"] = "Slide Shows"
#   slideshow_info["content_path"] = "slideshows"
# end

puts slideshows_info if BLOCH_VERBOSE

slideshows_output_file.write(JSON.pretty_generate(slideshows_info))
slideshows_output_file.close
