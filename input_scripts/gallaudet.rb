#Gallaudet aggregates chapter data from Ikarus (for galleries), Burgess (for passages), etc., and generates a list of all chapters, each with links to pages of all media applicable to that chapter.

#IDEAS: Include all media on SINGLE page for each chapter (with a jump-to menu?) | Include "previous" and "next" links (programmatically generated from Gallaudet output) to iterate either over chapters or over media pages within a chapter and then between chapters.

require "yaml"
require "json"
require "./ikarus.rb"

GALLAUDET_VERBOSE = false

def process_plain_media(media_manager, book_input_data_path, book_output_data_path)
  plain_info = YAML.load_file("#{INPUT_DATA_PATH}/#{book_input_data_path}/#{media_manager["input_data_path"]}/#{media_manager["input_data_file"]}")
  plain_output_file = File.open("#{OUTPUT_DATA_PATH}/#{book_output_data_path}/#{media_manager["output_filename"]}", "w")

  plain_info.each do |plain_info|
    plain_info["content_name"] = media_manager["content_name"]
    plain_info["content_path"] = media_manager["content_path"]
  end

  puts plain_info if GALLAUDET_VERBOSE

  plain_output_file.write(JSON.pretty_generate(plain_info))
  plain_output_file.close
end

def process_gallery_media(media_manager, book_input_data_path, book_output_data_path, book_image_path)
  ikarus_init("#{INPUT_DATA_PATH}/#{book_input_data_path}/#{media_manager["input_data_path"]}", "#{OUTPUT_DATA_PATH}/#{book_output_data_path}/#{media_manager["output_filename"]}", media_manager["input_data_file"], media_manager["input_data_entries_path"], book_image_path)
end

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
        entry = { "shortname" => media_entry["shortname"], "name" => media_entry["name"] }
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

INPUT_DATA_PATH = "../input_data/"
BOOKS_INPUT_FILE = "books.yaml"
BOOKS_OUTPUT_FILE = "books.json"
OUTPUT_DATA_PATH = "../data"

GALLAUDET_DATA_PATH = "."
GALLAUDET_CHAPTERS_FILENAME = "gallaudet_chapters.yaml"
GALLAUDET_OTHERS_FILENAME = "gallaudet_others.yaml"
GALLAUDET_CHAPTERS_OUTPUT_FILENAME = "gallaudet_chapters.json"
GALLAUDET_OTHERS_OUTPUT_FILENAME = "gallaudet_others.json"

books = YAML.load_file("#{INPUT_DATA_PATH}/#{BOOKS_INPUT_FILE}")

books.each do |book|
  book_input_data_path = book["shortname"]
  book_output_data_path = book["shortname"]
  book_image_path = book["shortname"]
  media_managers = book["media_managers"]

  gallaudet_chapters_output_file = File.open("#{OUTPUT_DATA_PATH}/#{book_output_data_path}/#{GALLAUDET_CHAPTERS_OUTPUT_FILENAME}", "w")
  gallaudet_others_output_file = File.open("#{OUTPUT_DATA_PATH}/#{book_output_data_path}/#{GALLAUDET_OTHERS_OUTPUT_FILENAME}", "w")
  gallaudet_chapters = YAML.load_file("#{INPUT_DATA_PATH}/#{book_input_data_path}/#{GALLAUDET_DATA_PATH}/#{GALLAUDET_CHAPTERS_FILENAME}")
  gallaudet_others = []

  if media_managers != nil
    media_managers.each do |media_manager|
      process_plain_media(media_manager, book_input_data_path, book_output_data_path) if media_manager["processing_type"] == "plain"
      process_gallery_media(media_manager, book_input_data_path, book_output_data_path, book_image_path) if media_manager["processing_type"] == "galleries"

      processing_output_file = JSON.parse(File.read("#{OUTPUT_DATA_PATH}/#{book_output_data_path}/#{media_manager["output_filename"]}"))
      add_media_to_chapter(processing_output_file, media_manager["name"], gallaudet_chapters, gallaudet_others)
    end
  end

  puts JSON.pretty_generate(gallaudet_chapters) if GALLAUDET_VERBOSE
  gallaudet_chapters_output_file.write(JSON.pretty_generate(gallaudet_chapters))
  gallaudet_others_output_file.write(JSON.pretty_generate(gallaudet_others))
end

books_output_file = File.open("#{OUTPUT_DATA_PATH}/#{BOOKS_OUTPUT_FILE}", "w")
books_output_file.write(JSON.pretty_generate(books))
