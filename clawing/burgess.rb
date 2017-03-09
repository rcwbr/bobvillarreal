require "yaml"
require "json"

BURGESS_VERBOSE = false

BURGESS_DATA_PATH = "burgess_data"
BURGESS_OUTPUT_FILENAME = "data/burgess_passages.json"
BURGESS_PASSAGES_DATA_FILE = "passages.yaml"
BURGESS_PASSAGES_DATA_PATH = "passages"

passages_info = YAML.load_file("#{BURGESS_DATA_PATH}/#{BURGESS_PASSAGES_DATA_FILE}")
passages_output_file = File.open(BURGESS_OUTPUT_FILENAME, "w")

passages_info.each do |passage_info|
  puts passage_info if BURGESS_VERBOSE
  passages = YAML.load_file("#{BURGESS_DATA_PATH}/#{BURGESS_PASSAGES_DATA_PATH}/#{passage_info["filename"]}")
  puts passages if BURGESS_VERBOSE
  passage_info["passages"] = passages if passages
  passage_info["content_name"] = "Passages"
  passage_info["content_path"] = "passages"
end

puts passages_info if BURGESS_VERBOSE

passages_output_file.write(JSON.pretty_generate(passages_info))
passages_output_file.close
