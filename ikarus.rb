require "yaml"
require "./curtiss_image_process.rb"

IKARUS_DATA_PATH = "ikarus_data"
GALLERIES_DATA_FILE = "galleries.yaml"
GALLERIES_DATA_PATH = "galleries"

galleries_data = YAML.load_file("#{IKARUS_DATA_PATH}/#{GALLERIES_DATA_FILE}")

# total_width = 960 #This is the width (in pixel) which Curtiss will make each row fit within. It also sets a number of style attributes from elsewhere in Middleman, where it is accessed by the config[:TOTAL_WIDTH] variable (see below).
# images_per_row = 4 #This is the number of images Curtiss will attempt to place on each row. If the imagesprocessed are not wide enough, it will add to this number until it fills the row. This is also accessed elsewhere in Middleman.
# image_margins = 10 #This is the number of pixels Curtiss will leave for margins BETWEEN images. It accounts for no margins around the gallery as a whole. It subtracts the number of pixels for margins times the ACTUAL number of images in the row (can be different than IMAGES_PER_ROW, as discussed above) from the TOTAL_WIDTH, and scales images in each row to fit that calculated width.
# width_adjustment = 2.0 #This is a number of pixels left blank on each row by default. Try adjusting this if images are wrapping before the end of their rows. The reason for this wiggle room is because pixel counts must be integers, and when rounding from the calculations used to scale images, there is a possibility of more pixels in a row than the TOTAL_WIDTH.
#overlay_thumb_height = 100 #This is the height of the list of thumbnails used in the overlay. This is not actually used by the image processing script, but it is the only other cofigurable variable used by the front end.

for i in 0...galleries_data.length
  gallery_shortname = galleries_data[i]["shortname"]
  gallery_filename = galleries_data[i]["data-file"]
  gallery_data = YAML.load_file("#{IKARUS_DATA_PATH}/#{GALLERIES_DATA_PATH}/#{gallery_filename}")
  puts "GALLERY: #{gallery_shortname}"
  for j in 0...gallery_data.length
    image_caption = gallery_data[j]["caption"]
    puts "Caption: #{image_caption}"
  end
end
