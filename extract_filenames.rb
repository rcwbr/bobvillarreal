def extract_filenames(yaml_gallery)
	filenames = []
	yaml_gallery.each do |image|
		filenames.append(image["filename"])
	end
	return filenames
end