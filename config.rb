###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

page "/galleries/*", :layout => "gallery"

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

activate :directory_indexes

require "curtiss_image_process.rb"

galleries = [
	{ "name" => "Ecuador - Chimborazo", "shortname" => "ecuador", "data-file" => "data/galleries/ecuador.yaml" },
	{ "name" => "Bolivia - Illimani", "shortname" => "bolivia", "data-file" => "data/galleries/bolivia.yaml" }
]
total_width = 960 #This is the width (in pixel) which Curtiss will make each row fit within. It also sets a number of style attributes from elsewhere in Middleman, where it is accessed by the config[:TOTAL_WIDTH] variable (see below).
images_per_row = 4 #This is the number of images Curtiss will attempt to place on each row. If the imagesprocessed are not wide enough, it will add to this number until it fills the row. This is also accessed elsewhere in Middleman.
image_margins = 10 #This is the number of pixels Curtiss will leave for margins BETWEEN images. It accounts for no margins around the gallery as a whole. It subtracts the number of pixels for margins times the ACTUAL number of images in the row (can be different than IMAGES_PER_ROW, as discussed above) from the TOTAL_WIDTH, and scales images in each row to fit that calculated width.
width_adjustment = 2.0 #This is a number of pixels left blank on each row by default. Try adjusting this if images are wrapping before the end of their rows. The reason for this wiggle room is because pixel counts must be integers, and when rounding from the calculations used to scale images, there is a possibility of more pixels in a row than the TOTAL_WIDTH.
overlay_thumb_height = 100 #This is the height of the list of thumbnails used in the overlay. This is not actually used by the image processing script, but it is the only other cofigurable variable used by the front end.

galleries.each do |gallery_info|
  filename_matrix = []
  filenames = []
  puts data.galleries[gallery_info["shortname"]]
  data.galleries[gallery_info["shortname"]].each do |image|
    filenames.append(image["filename"])
  end

  puts "hey #{filenames}"
  gallery_folder = "galleries/#{gallery_info["shortname"]}"
  thumbs_folder = "thumbs"
  curtiss_init(filename_matrix, filenames, gallery_folder, thumbs_folder, total_width, images_per_row, image_margins, width_adjustment)
	proxy "/galleries/#{gallery_info['shortname']}/index.html", "/templates/gallery.html", :locals => { :gallery_info => gallery_info, :filename_matrix => filename_matrix, :gallery_folder => gallery_folder, :thumbs_folder => thumbs_folder, :total_width => total_width, :images_per_row => images_per_row, :image_margins => image_margins, :width_adjustment => width_adjustment, :overlay_thumb_height => overlay_thumb_height}, :ignore => true
end



###
# Helpers
###

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

# Build-specific configuration
configure :build do
  config[:GALLERY_WIDTH] = total_width
  config[:IMAGE_MARGINS] = image_margins
  config[:WIDTH_ADJUSTMENT] = width_adjustment
  config[:OVERLAY_THUMB_HEIGHT] = overlay_thumb_height
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end
