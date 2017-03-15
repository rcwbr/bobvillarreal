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

page "/gallery/*", :layout => "gallery"
page "/chapter/*", :layout => "chapter"

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

activate :directory_indexes

CONFIG_VERBOSE = false

DATA_PATH = "data"
GALLERY_SITE_ROOT_PATH = "../../../"

books = JSON.parse(File.read("#{DATA_PATH}/books.json"))

books.each do |book|
	book_data_path = book["shortname"]

	media_managers = book["media_managers"]
	media_managers.each do |media_manager|
		media = JSON.parse(File.read("#{DATA_PATH}/#{book_data_path}/#{media_manager["output_filename"]}"))
		media.each do |media_entry|
			case media_manager["name"]
			when "ikarus"
				media_entry["images_path"] = "#{GALLERY_SITE_ROOT_PATH}#{media_entry["images_path"]}"
				proxy "/#{media_manager["content_path"]}/#{media_entry["shortname"]}/index.html", "/templates/gallery.html", :locals => { :gallery_info => media_entry }, :ignore => true
			when "burgess"
				proxy "/#{media_manager["content_path"]}/#{media_entry["shortname"]}/index.html", "/templates/passages.html", :locals => { :passages_info => media_entry }, :ignore => true
			when "macchi"
				proxy "/#{media_manager["content_path"]}/#{media_entry["shortname"]}/index.html", "/templates/movies.html", :locals => { :movies_info => media_entry }, :ignore => true
			when "bloch"
				proxy "/#{media_manager["content_path"]}/#{media_entry["shortname"]}/index.html", "/templates/slideshows.html", :locals => { :slideshows_info => media_entry }, :ignore => true
			when "hawker"
				proxy "/#{media_manager["content_path"]}/#{media_entry["shortname"]}/index.html", "/templates/tours.html", :locals => { :tour_info => media_entry }, :ignore => true
			end
		end
		proxy "/#{media_manager["content_path"]}/index.html", "/templates/#{media_manager["content_path"]}_index.html", :locals => { :media => media }, :ignore => true
	end

	chapters = JSON.parse(File.read("#{DATA_PATH}/#{book_data_path}/gallaudet_chapters.json"))
	chapters.each do |chapter_info|
		puts "CHAPTER: Name: #{chapter_info["name"]}" if CONFIG_VERBOSE
		if chapter_info["media"]["ikarus_data"]
			chapter_info["media"]["ikarus_data"]["images_path"] = "#{GALLERY_SITE_ROOT_PATH}#{chapter_info["media"]["ikarus_data"]["images_path"]}"
		end
		proxy "/chapter/#{chapter_info["shortname"]}/index.html", "/templates/chapter.html", :locals => { :chapter_info => chapter_info, :gallery_info => chapter_info["media"]["ikarus_data"], :passages_info => chapter_info["media"]["burgess_data"], :movies_info => chapter_info["media"]["macchi_data"], :tour_info => chapter_info["media"]["hawker_data"], :slideshows_info => chapter_info["media"]["bloch_data"] }, :ignore => true
	end
	others = JSON.parse(File.read("#{DATA_PATH}/#{book_data_path}/gallaudet_others.json"))
	proxy "/content/index.html", "/templates/content_index.html", :locals => { :chapters => chapters, :others => others }, :ignore => true
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
