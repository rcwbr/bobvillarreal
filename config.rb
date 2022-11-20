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

def build_chapter(chapter_info, book_data_path, book)
	puts "CHAPTER: Name: #{chapter_info["name"]}" if CONFIG_VERBOSE
	if chapter_info != nil and chapter_info["media"]["ikarus_data"]
		chapter_info["media"]["ikarus_data"]["images_path"] = "#{GALLERY_SITE_ROOT_PATH}#{chapter_info["media"]["ikarus_data"]["images_path"]}"
	end
	proxy "/#{book_data_path}/chapter/#{chapter_info["path"]}/index.html", "/templates/chapter.html", :locals => { :book => book, :chapter_info => chapter_info, :gallery_info => chapter_info["media"]["ikarus_data"], :passages_info => chapter_info["media"]["burgess_data"], :movies_info => chapter_info["media"]["macchi_data"], :tours_info => chapter_info["media"]["hawker_data"], :slideshows_info => chapter_info["media"]["bloch_data"] }, :ignore => true
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
	page "#{book_data_path}/historical/L*", :layout => "gallery"
	page "#{book_data_path}/historical/P*", :layout => "gallery"
	page "#{book_data_path}/historical/R*", :layout => "gallery"
	page "#{book_data_path}/historical/S*", :layout => "gallery"
	page "#{book_data_path}/historical/O*", :layout => "gallery"
	page "#{book_data_path}/historical/C*", :layout => "gallery"
	page "#{book_data_path}/historical/pachacamac*", :layout => "gallery"
	page "#{book_data_path}/historical/lima*", :layout => "gallery"
	page "#{book_data_path}/historical/*_prescott*", :layout => "gallery"
	page "#{book_data_path}/historical/assassination*", :layout => "gallery"
	page "#{book_data_path}/historical/tiwanaku*", :layout => "gallery"
	page "#{book_data_path}/historical/zarate*", :layout => "gallery"
	page "#{book_data_path}/historical/hemming*", :layout => "gallery"
	page "#{book_data_path}/historical/yupanqui*", :layout => "gallery"
	page "#{book_data_path}/historical/pasto*", :layout => "gallery"
	page "#{book_data_path}/historical/quito*", :layout => "gallery"
	page "#{book_data_path}/historical/pichincha*", :layout => "gallery"
	page "#{book_data_path}/historical/cayambe*", :layout => "gallery"
	page "#{book_data_path}/historical/cotopaxi*", :layout => "gallery"
	page "#{book_data_path}/historical/chimborazo*", :layout => "gallery"
	page "#{book_data_path}/historical/illimani*", :layout => "gallery"
	page "#{book_data_path}/historical/aconcagua*", :layout => "gallery"
	page "#{book_data_path}/historical/handbook*", :layout => "gallery"
	page "#{book_data_path}/historical/llama*", :layout => "gallery"
	page "#{book_data_path}/historical/machu*", :layout => "gallery"
	page "#{book_data_path}/historical/lapaz*", :layout => "gallery"
	page "#{book_data_path}/historical/cusco_franck*", :layout => "gallery"
	page "#{book_data_path}/historical/altitude*", :layout => "gallery"
	page "#{book_data_path}/historical/quito_franck*", :layout => "gallery"
	page "#{book_data_path}/historical/beetles*", :layout => "gallery"
	page "#{book_data_path}/historical/humboldt*", :layout => "gallery"
	page "#{book_data_path}/historical/condor*", :layout => "gallery"
	page "#{book_data_path}/historical/height*", :layout => "gallery"
	page "#{book_data_path}/historical/sacsayhuaman_squier*", :layout => "gallery"
	page "#{book_data_path}/historical/polish/", :layout => "gallery"
	page "#{book_data_path}/historical/cusco_leon*", :layout => "gallery"
	page "#{book_data_path}/historical/buenos_aires/", :layout => "gallery"
	page "#{book_data_path}/historical/orellana*", :layout => "gallery"
	page "#{book_data_path}/historical/names/", :layout => "gallery"
	page "#{book_data_path}/historical/carvahal*", :layout => "gallery"
	page "#{book_data_path}/historical/river*", :layout => "gallery"
	page "#{book_data_path}/chapter/*", :layout => "chapter"
	page "#{book_data_path}/historical/santiago_franck*", :layout => "gallery"
	page "#{book_data_path}/historical/mendoza_franck*", :layout => "gallery"
	page "#{book_data_path}/historical/cinnamon_pizarro*", :layout => "gallery"
	page "#{book_data_path}/historical/petition*", :layout => "gallery"


	non_content_pages = book["non_content_pages"]
	if non_content_pages != nil
		non_content_pages.each do |non_content_page|
			if !non_content_page["menu_only"]
				proxy "/#{book_data_path}/#{non_content_page["location"]}/index.html", "#{book_data_path}/#{non_content_page["filename"]}", :locals => { :book => book, :non_content_pages => non_content_pages }, :ignore => true
			end
		end
	end

	proxy "/#{book_data_path}/index.html", "#{book_data_path}/home.html", :locals => { :book => book, :non_content_pages => non_content_pages }, :ignore => true

  if book["shortname"] == "chronicles"
    media_entry = {"content_path" => "historical"}
    proxy "/#{book_data_path}/historical/prescott/index.html", "#{book_data_path}/prescott.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
    proxy "/#{book_data_path}/historical/vega/index.html", "#{book_data_path}/vega.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
    proxy "/#{book_data_path}/historical/new_laws/index.html", "#{book_data_path}/new_laws.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		proxy "/#{book_data_path}/historical/nautical/index.html", "#{book_data_path}/nautical.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry_template = {
			"content_path" => "historical",
			"tours" => []
		}
		tour_template = {
			"title" => "",
			"url" => "https://www.youtube.com/embed/1Z_hgWdbWPA"
		}
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/VyWkjBUFiio"
		proxy "/#{book_data_path}/historical/ollantaytambo/index.html", "#{book_data_path}/ollantaytambo.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/YgFXyDSNB8g"
		proxy "/#{book_data_path}/historical/sacsay/index.html", "#{book_data_path}/sacsay.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
	elsif book["shortname"] == "prelude"
    media_entry = {"content_path" => "historical"}
		proxy "/#{book_data_path}/historical/roping/index.html", "#{book_data_path}/roping.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		proxy "/#{book_data_path}/historical/apani/index.html", "#{book_data_path}/apani.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry_template = {
			"content_path" => "historical",
			"tours" => []
		}
		tour_template = {
			"title" => "",
			"url" => "https://www.youtube.com/embed/1Z_hgWdbWPA"
		}
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		proxy "/#{book_data_path}/historical/mariscal/index.html", "#{book_data_path}/mariscal.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/cujOvLTeKT8"
		proxy "/#{book_data_path}/historical/storms/index.html", "#{book_data_path}/storms.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/5ECzp3q3LCU"
		proxy "/#{book_data_path}/historical/la_paz_takeoff/index.html", "#{book_data_path}/la_paz_takeoff.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/i22GUZgW0mo"
		proxy "/#{book_data_path}/historical/la_paz_landing/index.html", "#{book_data_path}/la_paz_landing.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/NqBnw08LbU8"
		proxy "/#{book_data_path}/historical/cusco_landing/index.html", "#{book_data_path}/cusco_landing.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/ER2Jge7Ac7w"
		proxy "/#{book_data_path}/historical/cusco_train/index.html", "#{book_data_path}/cusco_train.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/9YAFpPXUPlM"
		proxy "/#{book_data_path}/historical/eruption_pichincha/index.html", "#{book_data_path}/eruption_pichincha.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/Iy1p_uiIgtg"
		proxy "/#{book_data_path}/historical/eruption_tungurahua/index.html", "#{book_data_path}/eruption_tungurahua.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/cnMa-Sm9H4k"
		proxy "/#{book_data_path}/historical/tour_machu_picchu/index.html", "#{book_data_path}/tour_machu_picchu.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/YvjDH8ElY2g"
		proxy "/#{book_data_path}/historical/expedia_quito/index.html", "#{book_data_path}/expedia_quito.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/be4-_NjhKZg"
		proxy "/#{book_data_path}/historical/asa_chimborazo/index.html", "#{book_data_path}/asa_chimborazo.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/vP05-dT07D0"
		proxy "/#{book_data_path}/historical/bmg_illimani/index.html", "#{book_data_path}/bmg_illimani.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = ""
		proxy "/#{book_data_path}/historical/polish_below/index.html", "#{book_data_path}/polish_below.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/Tca2ewgsBKI"
		proxy "/#{book_data_path}/historical/polish_notch/index.html", "#{book_data_path}/polish_notch.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/B7As2LMnd0U"
		proxy "/#{book_data_path}/historical/polish_above/index.html", "#{book_data_path}/polish_above.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.dailymotion.com/embed/video/x2tuahn?autoplay=1"
		proxy "/#{book_data_path}/historical/peru_la_paz/index.html", "#{book_data_path}/peru_la_paz.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/VUr14IfSPmI"
		proxy "/#{book_data_path}/historical/ollantaytambo/index.html", "#{book_data_path}/ollantaytambo.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/DNn9AYC7Zig"
		proxy "/#{book_data_path}/historical/ollantaytambo2/index.html", "#{book_data_path}/ollantaytambo2.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/VyWkjBUFiio"
		proxy "/#{book_data_path}/historical/ollantaytambo3/index.html", "#{book_data_path}/ollantaytambo3.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/m-rn8kElz7U"
		proxy "/#{book_data_path}/historical/huayna_picchu/index.html", "#{book_data_path}/huayna_picchu.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/68AAAs73su8"
		proxy "/#{book_data_path}/historical/sacsay/index.html", "#{book_data_path}/sacsay.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/Y6vf-2A9Reg"
		proxy "/#{book_data_path}/historical/mp_pueblo/index.html", "#{book_data_path}/mp_pueblo.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/WImT7lEij_M"
		proxy "/#{book_data_path}/historical/bus_ride/index.html", "#{book_data_path}/bus_ride.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/cbL-K_9-YB8"
		proxy "/#{book_data_path}/historical/flyover_illimani/index.html", "#{book_data_path}/flyover_illimani.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/elfdy-kUz6I"
		proxy "/#{book_data_path}/historical/flyover_tiwanaku/index.html", "#{book_data_path}/flyover_tiwanaku.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/dXqU_apjvXU"
		proxy "/#{book_data_path}/historical/la_paz_tour/index.html", "#{book_data_path}/la_paz_tour.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/xMFf0DeSrAk"
		proxy "/#{book_data_path}/historical/la_paz_cholitas/index.html", "#{book_data_path}/la_paz_cholitas.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/LJz1Qvh-Bbw"
		proxy "/#{book_data_path}/historical/isla_del_sol/index.html", "#{book_data_path}/isla_del_sol.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/Gkl-ilU8cdg"
		proxy "/#{book_data_path}/historical/alpamayo/index.html", "#{book_data_path}/alpamayo.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/YsyNbvJoo74"
		proxy "/#{book_data_path}/historical/polish_direct/index.html", "#{book_data_path}/polish_direct.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/4VrbAY8flWA"
		proxy "/#{book_data_path}/historical/santiago_mendoza/index.html", "#{book_data_path}/santiago_mendoza.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/bKc9m7xfOyM"
		proxy "/#{book_data_path}/historical/los_caracoles/index.html", "#{book_data_path}/los_caracoles.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/nW56kQ9SjJY"
		proxy "/#{book_data_path}/historical/driving_los_caracoles/index.html", "#{book_data_path}/driving_los_caracoles.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
	end
	if book["shortname"] == "prelude" || book["shortname"] == "chronicles"
		media_entry_template = {
			"content_path" => "historical",
			"tours" => []
		}
		tour_template = {
			"title" => "",
			"url" => "https://www.youtube.com/embed/1Z_hgWdbWPA"
		}
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/2B43KdtArvI"
		proxy "/#{book_data_path}/historical/cusco_tour/index.html", "#{book_data_path}/cusco_tour.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/LArO19qw8iw"
		proxy "/#{book_data_path}/historical/exposa_quito/index.html", "#{book_data_path}/exposa_quito.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
  end
	if book["shortname"] == "az"
		media_entry_template = {
			"content_path" => "historical",
			"tours" => []
		}
		tour_template = {
			"title" => "",
			"url" => "https://www.youtube.com/embed/AI9i9FbHkjs"
		}
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/AI9i9FbHkjs"
		proxy "/#{book_data_path}/historical/dance/index.html", "#{book_data_path}/dance.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/Oqgz1PLRmM8"
		proxy "/#{book_data_path}/historical/tributary/index.html", "#{book_data_path}/tributary.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/QOPSOeSUl_k"
		proxy "/#{book_data_path}/historical/tributary2/index.html", "#{book_data_path}/tributary2.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/hkXGgSZFdBs"
		proxy "/#{book_data_path}/historical/iquitos_to_manaus/index.html", "#{book_data_path}/iquitos_to_manaus.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
		media_entry = media_entry_template.clone
		media_entry["tours"] = [ tour_template.clone ]
		media_entry["tours"][0]["url"] = "https://www.youtube.com/embed/Zg65rB-z66Q"
		proxy "/#{book_data_path}/historical/fire/index.html", "#{book_data_path}/fire.html", :locals => { :book => book, :media_entry => media_entry }, :ignore => true
	end

	media_managers = book["media_managers"]
	if media_managers != nil
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
					if media_entry["volume"] then
						media_entry["sections"].each do |media_section_entry|
							build_gallery_sections(media_section_entry, GALLERY_SITE_ROOT_PATH, book_data_path, media_manager, book)
						end
					else
						build_gallery_sections(media_entry, GALLERY_SITE_ROOT_PATH, book_data_path, media_manager, book)
					end
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
			if media_manager["content_path"] == 'historical'
				proxy "/#{book_data_path}/#{media_manager["content_path"]}/index.html", "/templates/historical_index.html", :locals => { :book => book, :media_manager => media_manager, :media => media }, :ignore => true
			else
				proxy "/#{book_data_path}/#{media_manager["content_path"]}/index.html", "/templates/#{media_manager["content_type"]}_index.html", :locals => { :book => book, :media_manager => media_manager, :media => media }, :ignore => true
			end
		end
	end

	chapters = JSON.parse(File.read("#{DATA_PATH}/#{book_data_path}/gallaudet_chapters.json"))
	chapters.each do |volume|
		if volume != nil
			if volume["chapters"]
				volume["chapters"].each do |chapter|
					build_chapter(chapter, book_data_path, book)
				end
			else
				build_chapter(volume, book_data_path, book)
			end
		end
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
