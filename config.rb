require "json"

def build_gallery(media_entry, gallery_site_root_path, book_data_path, media_manager, book)
	media_entry["images_path"] = "#{gallery_site_root_path}#{media_entry["images_path"]}"
	proxy "/#{book_data_path}/#{media_manager["content_path"]}/#{media_entry["path"]}/index.html", "/templates/gallery.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
end

def build_gallery_sections(media_entry, gallery_site_root_path, book_data_path, media_manager, book)
	if media_entry["section"]
		media_entry["galleries"].each do |section_entry|
			build_gallery(section_entry, gallery_site_root_path, book_data_path, media_manager, book)
		end
	else
		build_gallery(media_entry, gallery_site_root_path, book_data_path, media_manager, book)
	end
end

def build_entry(book_data_path, media_manager, media_entry, book, media_template)
	proxy "/#{book_data_path}/#{media_manager["content_path"]}/#{media_entry["path"]}/index.html", media_template, :locals => { :book => book, :media_entry => media_entry }, :ignore => true
end

def build_sections(media_entry, book_data_path, media_manager, book, media_template)
	if media_entry["section"]
		media_entry[media_manager["content_type"]].each do |section_entry|
			build_entry(book_data_path, media_manager, section_entry, book, media_template)
		end
	else
		build_entry(book_data_path, media_manager, media_entry, book, media_template)
	end
end

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


# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

activate :directory_indexes

CONFIG_VERBOSE = false

DATA_PATH = "data"
GALLERY_SITE_ROOT_PATH = "../../../"

books = JSON.parse(File.read("#{DATA_PATH}/books.json"))

page "/index.html", :layout => "landing"
proxy "/index.html", "landing.html", :locals => { :books => books }, :ignore => true

books.each do |book|
	book_data_path = book["shortname"]

	page "#{book_data_path}/galleries/*", :layout => "gallery"
	page "#{book_data_path}/paintings/*", :layout => "gallery"
	page "#{book_data_path}/letters/*", :layout => "gallery"
	page "#{book_data_path}/chapter/*", :layout => "chapter"


	non_content_pages = book["non_content_pages"]
	non_content_pages.each do |non_content_page|
		if !non_content_page["menu_only"]
			proxy "/#{book_data_path}/#{non_content_page["location"]}/index.html", "#{book_data_path}/#{non_content_page["filename"]}", :locals => { :book => book, :non_content_pages => non_content_pages }, :ignore => true
		end
	end

	proxy "/#{book_data_path}/index.html", "#{book_data_path}/home.html", :locals => { :book => book, :non_content_pages => non_content_pages }, :ignore => true

	media_managers = book["media_managers"]
	media_managers.each do |media_manager|
		media = JSON.parse(File.read("#{DATA_PATH}/#{book_data_path}/#{media_manager["output_filename"]}"))
		media.each do |media_entry|
			case media_manager["name"]
			when "burgess"
				if media_entry["section"]
					media_entry["passages"].each do |section_entry|
						proxy "/#{book_data_path}/#{media_manager["content_path"]}/#{section_entry["path"]}/index.html", "/templates/passages.html", :locals => { :book => book, :media_entry => section_entry }, :ignore => true
					end
				else
					proxy "/#{book_data_path}/#{media_manager["content_path"]}/#{media_entry["path"]}/index.html", "/templates/passages.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
				end
			when "ikarus"
				if media_entry["volume"] then
					media_entry["sections"].each do |media_section_entry|
						build_gallery_sections(media_section_entry, GALLERY_SITE_ROOT_PATH, book_data_path, media_manager, book)
					end
				else
					build_gallery_sections(media_entry, GALLERY_SITE_ROOT_PATH, book_data_path, media_manager, book)
				end

			when "gloster"
				if media_entry["volume"]
					media_entry["galleries"].each do |gallery|
						build_gallery(gallery, GALLERY_SITE_ROOT_PATH, book_data_path, media_manager, book)
					end
				end
			when "vought"
				media_entry["images_path"] = "#{GALLERY_SITE_ROOT_PATH}#{media_entry["images_path"]}"
				proxy "/#{book_data_path}/#{media_manager["content_path"]}/#{media_entry["path"]}/index.html", "/templates/gallery.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
			when "bloch"
				proxy "/#{book_data_path}/#{media_manager["content_path"]}/#{media_entry["path"]}/index.html", "/templates/slideshows.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
			when "hawker"
				if media_entry["volume"]
					media_entry["sections"].each do |media_section_entry|
						build_sections(media_section_entry, book_data_path, media_manager, book, "/templates/tours.html")
					end
				else
					build_sections(media_entry, book_data_path, media_manager, book, "/templates/tours.html")
				end
			when "macchi"
				proxy "/#{book_data_path}/#{media_manager["content_path"]}/#{media_entry["path"]}/index.html", "/templates/movies.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
			end
		end
		proxy "/#{book_data_path}/#{media_manager["content_path"]}/index.html", "/templates/#{media_manager["content_type"]}_index.html", :locals => { :book => book, :media_manager => media_manager, :media => media }, :ignore => true
	end

	chapters = JSON.parse(File.read("#{DATA_PATH}/#{book_data_path}/gallaudet_chapters.json"))
	chapters.each do |chapter_info|
		puts "CHAPTER: Name: #{chapter_info["name"]}" if CONFIG_VERBOSE
		if chapter_info["media"]["ikarus_data"]
			chapter_info["media"]["ikarus_data"]["images_path"] = "#{GALLERY_SITE_ROOT_PATH}#{chapter_info["media"]["ikarus_data"]["images_path"]}"
		end
		proxy "/#{book_data_path}/chapter/#{chapter_info["path"]}/index.html", "/templates/chapter.html", :locals => { :book => book, :chapter_info => chapter_info, :gallery_info => chapter_info["media"]["ikarus_data"], :passages_info => chapter_info["media"]["burgess_data"], :movies_info => chapter_info["media"]["macchi_data"], :tours_info => chapter_info["media"]["hawker_data"], :slideshows_info => chapter_info["media"]["bloch_data"] }, :ignore => true
	end
	others = JSON.parse(File.read("#{DATA_PATH}/#{book_data_path}/gallaudet_others.json"))
	proxy "/#{book_data_path}/chapters/index.html", "/templates/chapters_index.html", :locals => { :book => book, :chapters => chapters, :others => others }, :ignore => true
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
