require "yaml"
require "./curtiss_image_process.rb"

IKARUS_DATA_PATH = "ikarus_data"
GALLERIES_DATA_FILE = "galleries.yaml"
GALLERIES_DATA_PATH = "galleries"
DEFAULT_GALLERY_IMAGE_PATH = "source/galleries"
DEFAULT_GALLERY_THUMB_FOLDER_PATH = "thumbs"
DEFAULT_GALLERY_TOTAL_WIDTH = 960
DEFAULT_GALLERY_IMAGES_PER_ROW = 4
DEFAULT_GALLERY_IMAGE_MARGINS = 10
DEFAULT_GALLERY_WIDTH_ADJUSTMENT = 2
DEFAULT_GALLERY_OVERLAY_THUMB_HEIGHT = 100

galleries_data = YAML.load_file("#{IKARUS_DATA_PATH}/#{GALLERIES_DATA_FILE}")

# total_width = 960 #This is the width (in pixel) which Curtiss will make each row fit within. It also sets a number of style attributes from elsewhere in Middleman, where it is accessed by the config[:TOTAL_WIDTH] variable (see below).
# images_per_row = 4 #This is the number of images Curtiss will attempt to place on each row. If the imagesprocessed are not wide enough, it will add to this number until it fills the row. This is also accessed elsewhere in Middleman.
# image_margins = 10 #This is the number of pixels Curtiss will leave for margins BETWEEN images. It accounts for no margins around the gallery as a whole. It subtracts the number of pixels for margins times the ACTUAL number of images in the row (can be different than IMAGES_PER_ROW, as discussed above) from the TOTAL_WIDTH, and scales images in each row to fit that calculated width.
# width_adjustment = 2.0 #This is a number of pixels left blank on each row by default. Try adjusting this if images are wrapping before the end of their rows. The reason for this wiggle room is because pixel counts must be integers, and when rounding from the calculations used to scale images, there is a possibility of more pixels in a row than the TOTAL_WIDTH.
#overlay_thumb_height = 100 #This is the height of the list of thumbnails used in the overlay. This is not actually used by the image processing script, but it is the only other cofigurable variable used by the front end.

for i in 0...galleries_data.length
  gallery_name = galleries_data[i]["name"]
  gallery_filename = galleries_data[i]["data-file"]

  gallery_shortname = gallery_name
  if galleries_data[i]["shortname"] != nil
    gallery_shortname = galleries_data[i]["shortname"]
  end
  gallery_image_path = DEFAULT_GALLERY_IMAGE_PATH
  if galleries_data[i]["image_path"] != nil
    gallery_image_path = galleries_data[i]["image_path"]
  end
  gallery_thumb_folder_path = DEFAULT_GALLERY_THUMB_FOLDER_PATH
  if galleries_data[i]["thumb_folder_path"] != nil
    gallery_thumb_folder_path = galleries_data[i]["thumb_folder_path"]
  end
  gallery_total_width = DEFAULT_GALLERY_TOTAL_WIDTH
  if galleries_data[i]["total_width"] != nil
    gallery_total_width = galleries_data[i]["total_width"]
  end
  gallery_images_per_row = DEFAULT_GALLERY_IMAGES_PER_ROW
  if galleries_data[i]["images_per_row"] != nil
    gallery_images_per_row = galleries_data[i]["images_per_row"]
  end
  gallery_image_margins = DEFAULT_GALLERY_IMAGE_MARGINS
  if galleries_data[i]["image_margins"] != nil
    gallery_image_margins = galleries_data[i]["image_margins"]
  end
  gallery_width_adjustment = DEFAULT_GALLERY_WIDTH_ADJUSTMENT
  if galleries_data[i]["width_adjustment"] != nil
    gallery_width_adjustment = galleries_data[i]["width_adjustment"]
  end
  gallery_overlay_thumb_height = DEFAULT_GALLERY_OVERLAY_THUMB_HEIGHT
  if galleries_data[i]["overlay_thumb_height"] != nil
    gallery_overlay_thumb_height = galleries_data[i]["overlay_thumb_height"]
  end

  puts "GALLERY: #{gallery_name} | #{gallery_shortname} | #{gallery_image_path} | #{gallery_thumb_folder_path}"

  gallery_filename_matrix = []

  gallery_data = YAML.load_file("#{IKARUS_DATA_PATH}/#{GALLERIES_DATA_PATH}/#{gallery_filename}")
  for j in 0...gallery_data.length
    image_caption = gallery_data[j]["caption"]
  end
  #curtiss_init(gallery, filenames, gallery_folder, thumbs_folder, total_width, images_per_row, image_margins, width_adjustment)
end
