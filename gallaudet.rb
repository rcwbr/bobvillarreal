#Gallaudet aggregates chapter data from Ikarus (for galleries), Burgess (for passages), etc., and generates a list of all chapters, each with links to pages of all media applicable to that chapter.

#IDEAS: Include all media on SINGLE page for each chapter (with a jump-to menu?) | Include "previous" and "next" links (programmatically generated from Gallaudet output) to iterate either over chapters or over media pages within a chapter and then between chapters.

require "yaml"
require "json"

GALLAUDET_VERBOSE = false

OUTPUT_DATA_PATH = "data"
IKARUS_OUTPUT_FILENAME = "ikarus_galleries.json"
BURGESS_OUTPUT_FILENAME = "burgess_passages.json"

GALLAUDET_DATA_PATH = "."
GALLAUDET_DATA_FILENAME = "gallaudet_chapters.yaml"
GALLAUDET_OUTPUT_FILENAME = "gallaudet_chapters.json"

def add_media_to_chapter(media, media_manager_name, chapters)
  puts "Adding media to chapter" if GALLAUDET_VERBOSE
  chapters.each do |chapter|
    media.each do |media_entry|
      puts "#{media_manager_name} \"#{chapter["name"]}\" \"#{media_entry["name"]}\"" if GALLAUDET_VERBOSE
      if chapter["name"] == media_entry["name"]
        chapter[media_manager_name + "_data"] = media_entry
      end
    end
  end
end

ikarus_output = JSON.parse(File.read(OUTPUT_DATA_PATH + "/" + IKARUS_OUTPUT_FILENAME))
puts ikarus_output if GALLAUDET_VERBOSE
burgess_output = JSON.parse(File.read(OUTPUT_DATA_PATH + "/" + BURGESS_OUTPUT_FILENAME))
puts burgess_output if GALLAUDET_VERBOSE

gallaudet_output_file = File.open(OUTPUT_DATA_PATH + "/" + GALLAUDET_OUTPUT_FILENAME, "w")
gallaudet_chapters = YAML.load_file("#{GALLAUDET_DATA_PATH}/#{GALLAUDET_DATA_FILENAME}")

add_media_to_chapter(ikarus_output, "ikarus", gallaudet_chapters)
add_media_to_chapter(burgess_output, "burgess", gallaudet_chapters)
puts JSON.pretty_generate(gallaudet_chapters) if GALLAUDET_VERBOSE
gallaudet_output_file.write(JSON.pretty_generate(gallaudet_chapters))
