#Gallaudet aggregates chapter data from Ikarus (for galleries), Burgess (for passages), etc., and generates a list of all chapters, each with links to pages of all media applicable to that chapter.

#IDEAS: Include all media on SINGLE page for each chapter (with a jump-to menu?) | Include "previous" and "next" links (programmatically generated from Gallaudet output) to iterate either over chapters or over media pages within a chapter and then between chapters.

require "yaml"
require "json"

GALLAUDET_VERBOSE = true

IKARUS_OUTPUT_FILENAME = "ikarus_galleries.json"
BURGESS_OUTPUT_FILENAME = "burgess_passages.json"

GALLAUDET_OUTPUT_FILENAME = "gallaudet_chapters.json"
