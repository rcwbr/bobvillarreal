require "yaml"
require "json"
require "./curtiss_image_process.rb"

IKARUS_VERBOSE = false

GALLERY_DEFAULTS = {
  "images_path" => "images/galleries",
  "source_path" => "../source",
  "thumbs_folder_path" => "thumbs",
  "total_width" => 960,  #This is the width (in pixel) which Curtiss will make each row fit within. It also sets a number of style attributes from elsewhere in Middleman, where it is accessed by the config[:TOTAL_WIDTH] variable (see below).
  "images_per_row" => 4, #This is the number of images Curtiss will attempt to place on each row. If the imagesprocessed are not wide enough, it will add to this number until it fills the row. This is also accessed elsewhere in Middleman.
  "image_margins" => 10, #This is the number of pixels Curtiss will leave for margins BETWEEN images. It accounts for no margins around the gallery as a whole. It subtracts the number of pixels for margins times the ACTUAL number of images in the row (can be different than IMAGES_PER_ROW, as discussed above) from the TOTAL_WIDTH, and scales images in each row to fit that calculated width.
  "width_adjustment" => 2, #This is a number of pixels left blank on each row by default. Try adjusting this if images are wrapping before the end of their rows. The reason for this wiggle room is because pixel counts must be integers, and when rounding from the calculations used to scale images, there is a possibility of more pixels in a row than the TOTAL_WIDTH.
  "overlay_thumb_height" => 100 #This is the height of the list of thumbnails used in the overlay. This is not actually used by the image processing script, but it is the only other cofigurable variable used by the front end.
}
IMAGE_DEFAULTS = {
  "caption" => "",
  "attribution" => ""
}

def ikarus_init(ikarus_data_path, ikarus_output_filename, galleries_data_file, galleries_data_path)

  galleries_info = YAML.load_file("#{ikarus_data_path}/#{galleries_data_file}")
  galleries_json_file = File.open(ikarus_output_filename, "w")

  for gallery_counter in 0...galleries_info.length

    if galleries_info[gallery_counter]["shortname"] == nil
      galleries_info[gallery_counter]["shortname"] = galleries_info[gallery_counter]["name"]
    end
    if galleries_info[gallery_counter]["images_path"] == nil
      galleries_info[gallery_counter]["images_path"] = "#{GALLERY_DEFAULTS["images_path"]}/#{galleries_info[gallery_counter]["shortname"]}"
    end

    for gallery_defaults_counter in 1...GALLERY_DEFAULTS.keys.length
      if galleries_info[gallery_counter][GALLERY_DEFAULTS.keys[gallery_defaults_counter]] == nil
        galleries_info[gallery_counter][GALLERY_DEFAULTS.keys[gallery_defaults_counter]] = GALLERY_DEFAULTS[GALLERY_DEFAULTS.keys[gallery_defaults_counter]]
      end
    end

    puts "IKARUS: #{galleries_info[gallery_counter]["name"]} | #{galleries_info[gallery_counter]["shortname"]} | #{galleries_info[gallery_counter]["source_path"]} | #{galleries_info[gallery_counter]["images_path"]} | #{galleries_info[gallery_counter]["thumbs_folder_path"]} | #{galleries_info[gallery_counter]["total_width"]} | #{galleries_info[gallery_counter]["images_per_row"]} | #{galleries_info[gallery_counter]["image_margins"]} | #{galleries_info[gallery_counter]["width_adjustment"]}" if IKARUS_VERBOSE

    galleries_info[gallery_counter]["image_matrix"] = []

    gallery_images_info = YAML.load_file("#{ikarus_data_path}/#{galleries_data_path}/#{galleries_info[gallery_counter]["filename"]}")
    label_counter = 1
    for image_counter in 0...gallery_images_info.length
      for images_defaults_counter in 0...IMAGE_DEFAULTS.length
        if gallery_images_info[image_counter][IMAGE_DEFAULTS.keys[images_defaults_counter]] == nil
          gallery_images_info[image_counter][IMAGE_DEFAULTS.keys[images_defaults_counter]] = IMAGE_DEFAULTS[IMAGE_DEFAULTS.keys[images_defaults_counter]]
        end
      end
      if gallery_images_info[image_counter]["label"] == nil
        gallery_images_info[image_counter]["label"] = label_counter.to_s
        label_counter += 1
      end
    end

    curtiss_init(galleries_info[gallery_counter]["image_matrix"], gallery_images_info, "#{galleries_info[gallery_counter]["source_path"]}/#{galleries_info[gallery_counter]["images_path"]}", galleries_info[gallery_counter]["thumbs_folder_path"], galleries_info[gallery_counter]["total_width"], galleries_info[gallery_counter]["images_per_row"], galleries_info[gallery_counter]["image_margins"], galleries_info[gallery_counter]["width_adjustment"])

    for i in 0...galleries_info[gallery_counter]["image_matrix"].length
      print "IKARUS: " if IKARUS_VERBOSE
      for j in 0...galleries_info[gallery_counter]["image_matrix"][i].length
        print "#{galleries_info[gallery_counter]["image_matrix"][i][j]} " if IKARUS_VERBOSE
      end
      puts "" if IKARUS_VERBOSE
    end

    galleries_info[gallery_counter]["content_name"] = "Galleries"
    galleries_info[gallery_counter]["content_path"] = "galleries"
  end

  galleries_json_file.write(JSON.pretty_generate(galleries_info))
  galleries_json_file.close
end
