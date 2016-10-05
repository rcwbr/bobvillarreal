require "yaml"
require "./curtiss_image_process.rb"

galleries = YAML.load_file("data/galleries.yaml")

for i in 0...galleries.length
  gallery_shortname = galleries[i]["shortname"]
  gallery = YAML.load_file("data/galleries/#{gallery_shortname}.yaml")
  #for j in 0...gallery.length
    puts "GALLERY: #{gallery_name}"
  #end
end
