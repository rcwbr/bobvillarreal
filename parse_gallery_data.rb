=begin
regex to convert old html files
all
find: "
replace: \"

captions
find:
</li>
<li id=\\"[^\s]+\\">
replace: ","

filenames
find: \>

replace: ","
=end
raw_captions = []
raw_filenames = []

label_index = 1

raw_captions.each_with_index do |caption, index|
  puts "-"
  puts "  caption: \"#{caption.gsub("\"", "\\\\\\\\\\\\\"")}\""
  filename = raw_filenames[index][raw_filenames[index].index("image")..raw_filenames[index].index("\" ") - 1]
  puts "  filename: #{filename}"
  image_label = filename[5..filename.index(".") - 1]
  if "#{label_index}" != image_label
    puts "  label: #{image_label}"
  else
    label_index += 1
  end
end
