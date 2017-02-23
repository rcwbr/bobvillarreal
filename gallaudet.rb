#Gallaudet aggregates chapter data from Ikarus (for galleries), Burgess (for passages), etc., and generates a list of all chapters, each with links to pages of all media applicable to that chapter.

#IDEAS: Include all media on SINGLE page for each chapter (with a jump-to menu?) | Include "previous" and "next" links (programmatically generated from Gallaudet output) to iterate either over chapters or over media pages within a chapter and then between chapters.

require "yaml"
require "json"

GALLAUDET_VERBOSE = false

OUTPUT_DATA_PATH = "data"
IKARUS_OUTPUT_FILENAME = "ikarus_galleries.json"
BURGESS_OUTPUT_FILENAME = "burgess_passages.json"
MACCHI_OUTPUT_FILENAME = "macchi_movies.json"
HAWKER_OUTPUT_FILENAME = "hawker_tours.json"
BLOCH_OUTPUT_FILENAME = "bloch_slideshows.json"

GALLAUDET_DATA_PATH = "."
GALLAUDET_CHAPTERS_FILENAME = "gallaudet_chapters.yaml"
GALLAUDET_OTHERS_FILENAME = "gallaudet_others.yaml"
GALLAUDET_CHAPTERS_OUTPUT_FILENAME = "gallaudet_chapters.json"
GALLAUDET_OTHERS_OUTPUT_FILENAME = "gallaudet_others.json"

def add_media_to_chapter(media, media_manager_name, chapters, others)
  puts "Adding media to chapter" if GALLAUDET_VERBOSE
  media.each do |media_entry|
    found_chapter = false
    chapters.each do |chapter|
      puts "#{media_manager_name} \"#{chapter["name"]}\" \"#{media_entry["name"]}\"" if GALLAUDET_VERBOSE
      if media_entry["name"] == chapter["name"]
        if chapter["media"] == nil
          chapter["media"] = {}
        end
        chapter["media"][media_manager_name + "_data"] = media_entry
        found_chapter = true
      end
    end
    if !found_chapter
      found_other = false
      others.each do |other|
        if media_entry["name"] == other["name"]
          found_other = true
          other["media"][media_manager_name + "_data"] = media_entry
        end
      end
      if !found_other
        entry = { :shortname => media_entry["shortname"], :name => media_entry["name"] }
        if media_entry["longname"] != nil
          entry["longname"] = media_entry["longname"]
        end
        entry["media"] = {}
        entry["media"][media_manager_name + "_data"] = media_entry
        others.push(entry)
      end
    end
  end
end

ikarus_output = JSON.parse(File.read(OUTPUT_DATA_PATH + "/" + IKARUS_OUTPUT_FILENAME))
puts ikarus_output if GALLAUDET_VERBOSE
burgess_output = JSON.parse(File.read(OUTPUT_DATA_PATH + "/" + BURGESS_OUTPUT_FILENAME))
puts burgess_output if GALLAUDET_VERBOSE
macchi_output = JSON.parse(File.read(OUTPUT_DATA_PATH + "/" + MACCHI_OUTPUT_FILENAME))
puts macchi_output if GALLAUDET_VERBOSE
hawker_output = JSON.parse(File.read(OUTPUT_DATA_PATH + "/" + HAWKER_OUTPUT_FILENAME))
puts hawker_output if GALLAUDET_VERBOSE
bloch_output = JSON.parse(File.read(OUTPUT_DATA_PATH + "/" + BLOCH_OUTPUT_FILENAME))
puts bloch_output if GALLAUDET_VERBOSE

gallaudet_chapters_output_file = File.open(OUTPUT_DATA_PATH + "/" + GALLAUDET_CHAPTERS_OUTPUT_FILENAME, "w")
gallaudet_others_output_file = File.open(OUTPUT_DATA_PATH + "/" + GALLAUDET_OTHERS_OUTPUT_FILENAME, "w")
gallaudet_chapters = YAML.load_file("#{GALLAUDET_DATA_PATH}/#{GALLAUDET_CHAPTERS_FILENAME}")
gallaudet_others = []

add_media_to_chapter(ikarus_output, "ikarus", gallaudet_chapters, gallaudet_others)
add_media_to_chapter(burgess_output, "burgess", gallaudet_chapters, gallaudet_others)
add_media_to_chapter(macchi_output, "macchi", gallaudet_chapters, gallaudet_others)
add_media_to_chapter(hawker_output, "hawker", gallaudet_chapters, gallaudet_others)
add_media_to_chapter(bloch_output, "bloch", gallaudet_chapters, gallaudet_others)
puts JSON.pretty_generate(gallaudet_chapters) if GALLAUDET_VERBOSE
gallaudet_chapters_output_file.write(JSON.pretty_generate(gallaudet_chapters))
gallaudet_others_output_file.write(JSON.pretty_generate(gallaudet_others))
