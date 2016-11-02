require "json"
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

galleries = JSON.parse(File.read("ikarus_galleries.json"));

#galleries = [
#	{ "name" => "Ecuador - Chimborazo", "shortname" => "ecuador", "data-file" => "data/galleries/ecuador.yaml" },
#	{ "name" => "Bolivia - Illimani", "shortname" => "bolivia", "data-file" => "data/galleries/bolivia.yaml" }
#]
galleries.each do |gallery_info|
	puts "GALLERY: #{gallery_info["name"]} | #{gallery_info["shortname"]} | #{gallery_info["images_path"]}"
	#, :locals => { , :filename_matrix => filename_matrix, :gallery_folder => gallery_folder, :thumbs_folder => thumbs_folder, :total_width => total_width, :images_per_row => images_per_row, :image_margins => image_margins, :width_adjustment => width_adjustment, :overlay_thumb_height => overlay_thumb_height}
	filename_matrix = [["image1.jpg", "image2.jpg", "image3.jpg", "image4.jpg"],["image5.jpg"]]
	gallery_folder =  gallery_info["images_path"] #"galleries/ecuador"
	thumbs_folder	= "thumbs"
	total_width = 960
	images_per_row = 4
	image_margins = 10
	width_adjustment = 10
	overlay_thumb_height = 100
	proxy "/galleries/#{gallery_info['shortname']}/index.html", "/templates/gallery.html", :locals => { :gallery_info => gallery_info, :filename_matrix => filename_matrix, :gallery_folder => gallery_folder, :thumbs_folder => thumbs_folder, :total_width => total_width, :images_per_row => images_per_row, :image_margins => image_margins, :width_adjustment => width_adjustment, :overlay_thumb_height => overlay_thumb_height }, :ignore => true
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
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end
